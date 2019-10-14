
require 'open-uri'
require 'open3'
require 'yaml'


class HttpAction < Struct.new(:url)
  def run
    open(url)
  end
end


class Reading < Struct.new(:score, :action, :interval)
end


class Actions
  attr_reader :yomi

  def initialize(conf)
    @table = {}
    @yomi = []

    id = 0

    conf.each do
      |entry|
      action =
        case av = entry['action']
        when %r[\Ahttps?://]
          HttpAction.new(av)
        else
          raise "Invalid action: #{av}"
        end

      interval = entry['interval'] || 5.0

      entry['phrase'].each do
        |ph|
        reading = ph['reading']
        score = ph['score']

        @table[id] = Reading.new(score, action, interval)

        @yomi << "#{id} #{reading}"

        id += 1
      end
    end
  end

  def get(id)
    @table[id]
  end
end



class Listener
  def initialize(config)
    @config = config
    @last = nil
  end

  def start(io)
    id = nil

    while line = io.gets
      line.chomp!
      key, value = *line.split(':').map(&:strip)

      case key
      when 'pass1_best'
        id = value
      when 'cmscore1'
        now = Time.now

        score = value.to_f
        reading = @config.get(id.to_i)
        raise "Reading id not matched: #{id}" unless reading

        unless !@last or reading.interval < (now - @last)
          STDERR.puts('In interval')
          next
        end

        if reading.score <= score
          reading.action.run
        else
          STDERR.puts("Low score: #{score} (#{id})")
        end

        @last = now
      end
    end
  end
end



if __FILE__ == $0
  config_file = ARGV.first

  actions = Actions.new(YAML.load(File.read(config_file)))

  yomi = IO.popen('gramtools/yomi2voca/yomi2voca.pl', 'r+') do
    |io|
    io.print(actions.yomi.join("\n").encode('EUC-JP'))
    io.close_write
    io.read.force_encoding('EUC-JP')
  end.encode('UTF-8')

  File.write('mimi.phone', yomi)

  yomi = IO.popen('./julius/julius -C mimi-base.jconf -C mimi.jconf', 'r') do
    |io|
    listener = Listener.new(actions)
    listener.start(io)
  end
end
