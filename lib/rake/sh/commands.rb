include Rake::Sh

Command.define 'help', 'h' do
  puts <<HELP
h, help    print help
t, tasks   print tasks
!, system  execute a system command
q, exit    exit from rake-sh
HELP
end

Command.define 'tasks', 't' do |arg|
  Rake.application.options.show_task_pattern = arg ? Regexp.new(arg) : //
  Rake.application.display_tasks_and_comments
end

Command.define 'exit', 'q' do
  exit
end

Command.define 'rake', 'r' do |arg|
  Rake::Sh.invoke(arg || :default)
end

Command.define 'system', '!' do |arg|
  system arg
end
