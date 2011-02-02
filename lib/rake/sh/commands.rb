include Rake::Sh

Command.define 'help' do
  puts <<HELP
.tasks       print tasks
.exit        exit from rake-sh
HELP
end

Command.define 'tasks' do |arg|
  Rake.application.options.show_task_pattern = arg ? Regexp.new(arg) : //
  Rake.application.display_tasks_and_comments
end

Command.define 'exit' do
  exit
end

Command.define 'rake' do |arg|
  Rake::Sh.invoke(arg || :default)
end

Command.define 'system' do |arg|
  system arg
end

Command.define '!' do |arg|
  Command[:system].call(arg)
end
