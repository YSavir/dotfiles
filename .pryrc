Pry.config.editor = 'vim'

require 'pry-bloodline'

PryBloodline.setup!

PryBloodline.configure do |c|
  c.line_color = :red
  c.name_color = :white
  c.path_color = :blue
  c.separator = "☯"
end

