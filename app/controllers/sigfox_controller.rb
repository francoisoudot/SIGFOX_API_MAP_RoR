class SigfoxController < ApplicationController
  def index
  	@devicetype=Devicetype.last(20)
  end

  def devicetype
    
    device_id=params['id']

   Devicetype.create(
   	:device_id=>device_id,
   	:time=>params['time'],
   	:data=>params['data'],
   	:rssi=>params['rssi'],
   	:signal=>params['signal'])

   # /JSON answer to the DL/

    if params['ack']=="true"
      # /change the data to send back/
      render :json=>{
        device_id => { "downlinkData" => "deadbeefbabebabe"}
      }
    else
      render :json=>''
    end

  end

  def gpslocation
    # binding.pry
    # /WARNING - TO CHANGE THE DEVICE ID/
    latestloc=Devicetype.order(created_at: :desc).where(device_id:"7FB28").limit(10)
    # /JSON render to optimise with a loop/
    render :json=>{
      "p0" => { "lat" => parse_coord(latestloc[0].data[0..7]),"lng"=>parse_coord(latestloc[0].data[8..15])}
      "p1" => { "lat" => parse_coord(latestloc[1].data[0..7]),"lng"=>parse_coord(latestloc[1].data[8..15])}
      "p2" => { "lat" => parse_coord(latestloc[2].data[0..7]),"lng"=>parse_coord(latestloc[2].data[8..15])}
      "p3" => { "lat" => parse_coord(latestloc[3].data[0..7]),"lng"=>parse_coord(latestloc[3].data[8..15])}
      "p4" => { "lat" => parse_coord(latestloc[4].data[0..7]),"lng"=>parse_coord(latestloc[4].data[8..15])}
      "p5" => { "lat" => parse_coord(latestloc[1].data[0..7]),"lng"=>parse_coord(latestloc[5].data[8..15])}
    }
  end

  def parse_coord(coord)
    dec_coord=coord[1..7].to_i(16).to_s(10)
    final_coord=dec_coord[0..dec_coord.size-7].to_f+(dec_coord[dec_coord.size-6..dec_coord.size-1].to_f/600000)
    if coord[0]=="8"
      final_coord=-final_coord
    end
    return final_coord.to_s
  end

end
