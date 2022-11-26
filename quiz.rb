$bus_672_stations = File.read('bus_672_stations.txt').split(',')
$bus_1816_stations = File.read('bus_1816_stations.txt').split(',')

puts 'Choose bus route number: (1816 or 672)'
until ($route = gets.chomp) =~ /1816|672/
  puts 'Only allow input 1816 or 672'
end

class Subscribe
  RECORDS = [
    { name: 'Sean', subscrib_route: '1816', final_station: '圓環', notify_previous_stations: 3 },
    { name: 'Peter', subscrib_route: '672', final_station: '博仁醫院', notify_previous_stations: 4 },
    { name: 'Joy', subscrib_route: '1816', final_station: '圓環', notify_previous_stations: 5 },
    { name: 'Joy', subscrib_route: '672', final_station: '博仁醫院', notify_previous_stations: 5 }
  ]

  class << self
    def by_route(route)
      RECORDS.select{ |record| record[:subscrib_route] == route }
    end
  end
end

class Context
  def call
    bus_stations.each_with_index do |station, index|
      puts "===================================="
      puts "Now Bus is arrived #{station}"
      notify_subscribed_user(station)

      unless index == (bus_stations.length - 1)
        puts "===================================="
        puts "                                    "
        puts "             on the way             "
        puts "                                    "
      end
      sleep 1
    end
  end

  private

  def bus_stations
    if $route == '1816'
      $bus_1816_stations
    elsif $route == '672'
      $bus_672_stations
    end
  end

  def notify_subscribed_user(station)
    subscribes = Subscribe.by_route($route)
    subscribes.each do |subscribe|
      puts "Notify to user #{ subscribe[:name] }" if need_noify?(subscribe, station)
    end
  end

  def need_noify?(subscribe, station)
    final_station = subscribe[:final_station]
    notify_previous_stations = subscribe[:notify_previous_stations]
    final_position = bus_stations.index(final_station)
    now_position = bus_stations.index(station)
    return false if (final_position - now_position) < 0
    (final_position - now_position) < notify_previous_stations
  end
end

Context.new.call
