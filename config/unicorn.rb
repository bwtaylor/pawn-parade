APP_HOME="#{ENV['PAWN_PARADE_HOME']}"

working_directory APP_HOME
pid "#{APP_HOME}/pids/unicorn.pid"

stderr_path "#{APP_HOME}/log/unicorn.log"
stdout_path "#{APP_HOME}/log/unicorn.log"

listen "/tmp/unicorn.pawn-parade.sock"
worker_processes 4
timeout 30
