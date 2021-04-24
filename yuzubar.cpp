#include <linkt/languages.hpp>
#include <iostream>
#include <fstream>
#include <thread>
#include <unistd.h>
#include <csignal>
#include <poll.h>
#include <sys/socket.h>

using std::cout;
using std::cerr;
using std::endl;

int lemonbar_pipe;
node::wrapper_s doc;
node::base_s bar_source;

char** config_paths;
int config_path_count;

void termhandle(int signal) {
  if (signal == SIGINT || signal == SIGTERM)
    exit(0);
}

void cleanup() {
  if (lemonbar_pipe) {
    close(lemonbar_pipe);
    lemonbar_pipe = 0;
  }
}

void load_node() {
  doc = std::make_shared<node::wrapper>();
  for (int i = 0; i < config_path_count; i++) {
    auto path = config_paths[i];
    std::ifstream file {path};
    if (file.fail()) {
      cerr << "Failed to load file: " << path << endl;
      continue;
    }
    node::errorlist err;
    parse_yml(file, err, doc);
    file.close();

    if (!err.empty()) {
      cerr << "Error while parsing file: " << path << endl;
      for (auto& e : err)
        cerr << "At " << e.first << ": " << e.second << endl;
      continue;
    }
  }

  node::clone_context context;
  doc->optimize(context);
  if (!context.errors.empty()) {
    cerr << "Error while optimizing:\n";
    for (auto& e : context.errors)
      cerr << "At " << e.first << ": " << e.second << endl;
    exit(1);
  }
  bar_source = doc->get_child_ptr("yuzubar"_ts);
  if (!bar_source) {
    cerr << "Failed to retrieve the key at 'yuzubar'";
    exit(1);
  }
}

void reloadhandle(int signal) {
  if (signal != SIGUSR1)
    return;
  load_node();
}

void print_help() {
  cout <<
    #include "command-line-help.txt"
    << endl;
}

void* my_memchr(void* ptr, int ch, long int count) {
  #pragma GCC diagnostic ignored "-Wsign-conversion"
  return count <= 0 ? nullptr : memchr(ptr, ch, count);
  #pragma GCC diagnostic pop
}

int main(int argc, char** argv) {
  const char* bar_cmd = "lemonbar";
  string bar_options = "";
  for (int sw; (sw = getopt(argc, argv, "l:hkf:")) != -1;) {
    switch (sw) {
      case 'l': bar_cmd = optarg; break;
      case 'h': print_help(); return 1;
      case 'f': bar_options = bar_options + " -f '" + optarg + "'"; break;
      case 'k':
        cout << "Killing previous instances of lemonbar and yuzubar" << endl;
        execl("/bin/pkill", "pkill", "yuzubar");
        execl("/bin/pkill", "pkill", "lemonbar");
        break;
    }
  } 

  config_paths = argv + optind;
  config_path_count = argc - optind;
  load_node();

  atexit(cleanup);
  signal(SIGUSR1, reloadhandle);
  signal(SIGINT, termhandle);
  signal(SIGTERM, termhandle);

  // Fork and call lemonbar
  int pipes[2];
  if (socketpair(AF_UNIX, SOCK_STREAM, 0, pipes) < 0)
    throw std::runtime_error("socketpair failed");
  switch(fork()) {
    case -1:
      close(pipes[0]);
      close(pipes[1]);
      throw std::runtime_error("fork failed");
    case 0: // Child case
      dup2(pipes[1], STDOUT_FILENO);
      dup2(pipes[1], STDIN_FILENO);
      close(pipes[0]);
      close(pipes[1]);
      execl("/usr/bin/sh", "sh", "-c", (bar_cmd + bar_options).data(), nullptr);
      return 127;
  }
  // Parent case
  lemonbar_pipe = pipes[0];
  close(pipes[1]);
  pollfd pollin{pipes[0], POLLIN, 0};

  string last_output = "";
  while (true) {
    if (poll(&pollin, 1, 0) > 0 && pollin.revents & POLLIN) {
      char buffer[128];
      char* buffer_end = buffer;
      while (true) {
        auto count = read(pipes[0], buffer, 128);
        if (count == 0) break;
        if (count < 0) {
          if (errno == EINTR) continue;
          return -1;
        }
        buffer_end += count;
        char* line_start = buffer, *newline;
        while ((newline = (char*)my_memchr(line_start, '\n', buffer_end - line_start))) {
          *newline = 0;
          if (!memcmp(line_start, "save ", 5)) {
            line_start += 5;
            for (; line_start < newline; line_start++)
              if (!std::isspace(*line_start))
                break;
            auto sep = (char*)my_memchr(line_start, '=', buffer_end - line_start);
            if (sep) {
              *sep = 0;
              if (!doc->set<string>(tstring(line_start), string(sep+1)))
                cerr << "Can't set key: " << line_start << endl;
            } else cerr << "Invalid: " << line_start << endl;
          } else {
            system(line_start);
          }
          line_start = newline + 1;
        }
        if (count < 128 || buffer[127] == '\n') break;
      }
    }

    auto now = std::chrono::steady_clock::now();
    try {
      auto result = bar_source->get();
      //cout << result << endl;
      if (result != last_output) {
        write(lemonbar_pipe, result.data(), result.size());
        last_output = result;
      }
    } catch (const std::exception& e) {
      cerr << "Error while retrieving key: " << e.what() << endl;
    }
    std::this_thread::sleep_until(now + std::chrono::milliseconds(50));
  }
}
