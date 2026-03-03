namespace :sidekiq do
  desc "Start Sidekiq"
  task :start do
    on roles(:app) do
      if test("sudo systemctl is-active --quiet sidekiq-qna")
        info "Sidekiq is already running"
      else
        execute "sudo systemctl start sidekiq-qna"
        info "Sidekiq started"
      end
    end
  end

  desc "Stop Sidekiq"
  task :stop do
    on roles(:app) do
      execute "sudo systemctl stop sidekiq-qna"
      info "Sidekiq stopped"
    end
  end

  desc "Restart Sidekiq"
  task :restart do
    on roles(:app) do
      execute "sudo systemctl restart sidekiq-qna"
      info "Sidekiq restarted"
    end
  end

  desc "Quiet Sidekiq (stop accepting new work)"
  task :quiet do
    on roles(:app) do
      execute "sudo systemctl kill -s TSTP sidekiq-qna"
      info "Sidekiq quieted"
    end
  end

  desc "Check Sidekiq status"
  task :status do
    on roles(:app) do
      info capture("sudo systemctl status sidekiq-qna")
    end
  end
end
