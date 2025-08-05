Ruby
require 'socket'
require 'json'

class SecurityToolController
  def initialize(host, port)
    @host = host
    @port = port
    @socket = TCPSocket.new(@host, @port)
  end

  def send_command(command)
    @socket.puts(command)
    response = @socket.gets
    JSON.parse(response)
  end

  def start_scan
    send_command('start_scan')
  end

  def stop_scan
    send_command('stop_scan')
  end

  def get_system_info
    send_command('get_system_info')
  end

  def get_scan_results
    send_command('get_scan_results')
  end

  def disconnect
    @socket.close
  end
end

class SecurityTool
  def initialize(controller)
    @controller = controller
  end

  def monitor_system
    while true
      system_info = @controller.get_system_info
      puts "System Info: #{system_info}"
      if system_info['vulnerabilities'].any?
        puts "Vulnerabilities detected! Starting scan..."
        @controller.start_scan
        sleep 10
        results = @controller.get_scan_results
        puts "Scan Results: #{results}"
        if results[' threats'].any?
          puts "Threats detected! Taking action..."
          # Take action to mitigate threats
        end
      end
      sleep 5
    end
  end
end

controller = SecurityToolController.new('localhost', 8080)
security_tool = SecurityTool.new(controller)
security_tool.monitor_system