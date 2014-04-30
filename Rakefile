# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks
task(:default).clear
task default: [:spec]


AppName = 'bte-staging'

%w[staging production testing].each do |e|
  task e.to_sym do ; end
end

##### Pushing to production -> rake production deploy
desc 'Push to target Heroku environment and run db:migrate'
task :deploy do
  target = ARGV.first
  if target == 'production'
    puts
    print "Pushing to production. Type 'yoyopushit' to continue: "
    if STDIN.gets.chomp == 'yoyopushit'
      Bundler.with_clean_env do
        system "heroku pgbackups:capture -e -a #{AppName}" or abort "aborted backing up production database"
      end
    else
      abort 'task aborted'
    end
  end

  command_list = [
    "git push -f git@heroku.com:#{AppName}.git #{target=='production' ? 'master' : 'HEAD'}:master",
    "heroku run rake db:migrate --app #{AppName}"
  ]
  puts "\n-----> #{command_list.join ' && '}\n"
  Bundler.with_clean_env do
    system command_list.join ' && '
  end
end

desc 'Enter Heroku console for target environment'
task :console do
  target = ARGV.first
  puts "Opening console for #{target}"
  Bundler.with_clean_env do
    system "heroku run console --app #{AppName}"
  end
end


desc 'Display heroku logs for target environment'
task :log do
  target = ARGV.first
  puts "Tailing logs for #{target}"
  Bundler.with_clean_env do
    system "heroku logs --tail --app #{AppName}"
  end
end