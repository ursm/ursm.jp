require 'pathname'
APP_ROOT = Pathname.new(__FILE__).join('../..')

Bluepill.application 'ursm.jp', :base_dir => APP_ROOT.join('tmp/pids') do |app|
  app.working_dir = APP_ROOT

  app.process 'web' do |process|
    process.start_command = %(spark app.coffee --port 3000 --env production --eval "require('coffee-script')")
    process.daemonize = true
    process.stdout = process.stderr = 'log/web.log'
  end

  app.process 'socket' do |process|
    process.start_command = %(spark app.coffee --port 8000 --env production --eval "require('coffee-script')")
    process.daemonize = true
    process.stdout = process.stderr = 'log/socket.log'
  end
end
