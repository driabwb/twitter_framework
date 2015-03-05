require_relative '../requests/UsersSuggestions'
require_relative '../requests/UsersSuggestionsCategories'

require 'trollop'

USAGE = %Q{
get_friends: Retrieve user ids that follow a given Twitter screen_name.

Usage:
  ruby get_followers.rb <options> [category]

  [category]: A Category of suggestions to be collected. This is the slug value that can be found from running this program without this parameter.

The following options are supported:
}

def parse_command_lines

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_suggestions 0.1 (c) 2015 Kenneth M. Anderson"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts[:category] = ARGV[0]
  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_lines
  if input[:category].nil?
    params = {}
  else
    params = { category: input[:category] }
  end

  data   = { props: input[:props] }

  args     = { params: params, data: data }

  twitter = nil
  fileName = ''

  if input[:category].nil?
    twitter = UsersSuggestionsCategories.new(args)
    fileName = 'user_suggestion_categories.txt'
    puts "Collecting the user suggestion Categories."

    File.open(fileName, 'w') do |f|
      twitter.collect do |ids|
        ids.each do |id|
          f.puts "#{id}\n"
        end
      end
    end

  else
    twitter = UsersSuggestions.new(args)
    fileName = 'user_suggestions_' + input[:category] + '.txt'
    puts "Collecting the user suggestions."

    File.open(fileName, 'w') do |f|
      twitter.collect do |ids|
        ids["users"].each do |id|
          f.puts "#{id}\n"
        end
      end
    end
          
  end

  puts "DONE."

end
