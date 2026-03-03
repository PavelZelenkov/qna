namespace :sidekiq do
  desc "Start Sidekiq"
  task :start do
    on roles(:app) do
      within current_path do
        if test("[ -f #{fetch(:sidekiq_pid)} ]") && test("kill -0 $(cat #{fetch(:sidekiq_pid)})")
          info "Sidekiq is already running"
        else
          execute :bundle, "exec sidekiq", 
                  "-e", fetch(:rails_env, "production"),
                  "-C", fetch(:sidekiq_config),
                  "-d",
                  "-L", File.join(current_path, 'log', 'sidekiq.log'),
                  "-P", fetch(:sidekiq_pid)
          info "Sidekiq started"
        end
      end
    end
  end

  desc "Stop Sidekiq"
  task :stop do
    on roles(:app) do
      within current_path do
        if test("[ -f #{fetch(:sidekiq_pid)} ]")
          execute :bundle, "exec sidekiqctl", "stop", fetch(:sidekiq_pid), "10"
          info "Sidekiq stopped"
        else
          info "Sidekiq pid file not found"
        end
      end
    end
  end

  desc "Restart Sidekiq"
  task :restart do
    invoke "sidekiq:stop"
    invoke "sidekiq:start"
  end

  desc "Quiet Sidekiq (stop accepting new work)"
  task :quiet do
    on roles(:app) do
      within current_path do
        if test("[ -f #{fetch(:sidekiq_pid)} ]")
          execute :kill, "-TSTP", "$(cat #{fetch(:sidekiq_pid)})"
          info "Sidekiq quieted"
        end
      end
    end
  end

  desc "Check Sidekiq status"
  task :status do
    on roles(:app) do
      within current_path do
        if test("[ -f #{fetch(:sidekiq_pid)} ]")
          pid = capture("cat #{fetch(:sidekiq_pid)}")
          if test("kill -0 #{pid}")
            info "Sidekiq is running (PID: #{pid})"
          else
            info "Sidekiq pid file exists but process not running"
          end
        else
          info "Sidekiq not running"
        end
      end
    end
  end
end
