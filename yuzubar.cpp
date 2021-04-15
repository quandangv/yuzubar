#include <linked/languages.hpp>
#include <iostream>
#include <fstream>
#include <thread>
#include <unistd.h>
#include <csignal>
#include <poll.h>
#include <sys/socket.h>

int lemonbar_pipe;
node::wrapper_s doc;
node::base_s bar_source;
const char* config_path;

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
  std::ifstream file {config_path};
  if (file.fail()) {
    std::cout << "Failed to load file '" << config_path << "'." << std::endl;
    exit(1);
  }
  node::errorlist err;
  doc = parse_yml(file, err);
  file.close();

  if (!err.empty()) {
    std::cerr << "Error while parsing:\n";
    for (auto& e : err)
      std::cerr << "At " << e.first << ": " << e.second << std::endl;
    exit(1);
  }
  node::clone_context context;
  doc->optimize(context);
  if (!context.errors.empty()) {
    std::cerr << "Error while optimizing:\n";
    for (auto& e : context.errors)
      std::cerr << "At " << e.first << ": " << e.second << std::endl;
    exit(1);
  }
  bar_source = doc->get_child_ptr("yuzubar"_ts);
  if (!bar_source) {
    std::cerr << "Failed to retrieve the key at 'yuzubar'";
    exit(1);
  }
}

void reloadhandle(int signal) {
  if (signal != SIGUSR1)
    return;
  load_node();
}

int main(int argc, char** argv) {
  if (argc < 2) {
    std::cout << "Usage: " << argv[0] << " <yzb-file> [lemonbar-launcher]" << std::endl;
    return 1;
  }
  config_path = argv[1];
  load_node();

  // Fork and call lemonbar
  atexit(cleanup);
  signal(SIGUSR1, reloadhandle);
  signal(SIGINT, termhandle);
  signal(SIGTERM, termhandle);
  int pipes[2];
  if (socketpair(AF_UNIX, SOCK_STREAM, 0, pipes) < 0)
    throw std::runtime_error("socketpair failed");
  switch(auto pid = fork()) {
    case -1:
      close(pipes[0]);
      close(pipes[1]);
      throw std::runtime_error("fork failed");
    case 0: // Child case
      dup2(pipes[1], STDOUT_FILENO);
      dup2(pipes[1], STDIN_FILENO);
      close(pipes[0]);
      close(pipes[1]);
      execl("/usr/bin/sh", "sh", "-c", argc > 2 ? argv[2] : "lemonbar", nullptr);
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
        while ((newline = (char*)memchr(line_start, '\n', buffer_end - line_start))) {
          *newline = 0;
          if (!memcmp(line_start, "save ", 5)) {
            line_start += 5;
            for (; line_start < newline; line_start++)
              if (!std::isspace(*line_start))
                break;
            auto sep = (char*)memchr(line_start, '=', buffer_end - line_start);
            if (sep) {
              *sep = 0;
              if (!doc->set<string>(tstring(line_start), string(sep+1)))
                std::cerr << "Can't set key: " << line_start << std::endl;
            } else std::cerr << "Invalid: " << line_start << std::endl;
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
      //std::cout << result << std::endl;
      if (result != last_output) {
        write(lemonbar_pipe, result.data(), result.size());
        last_output = result;
      }
    } catch (const std::exception& e) {
      std::cerr << "Error while retrieving key: " << e.what() << std::endl;
    }
    std::this_thread::sleep_until(now + std::chrono::milliseconds(50));
  }
}
