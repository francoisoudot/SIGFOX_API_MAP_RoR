class SigfoxController < ApplicationController
  def index
  	@devicetype=Devicetype.last(20)
  end

  def devicetype

    device_id=params['id']
    if (params['data'][0..15]=="0000000000000000") || (params['data'].size!=24)
      gps=false
    else
      gps=true
    end
   Devicetype.create(
   	:device_id=>device_id,
   	:time=>params['time'],
   	:data=>params['data'],
   	:rssi=>params['rssi'],
   	:signal=>params['signal'],
    :gps=>gps)

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
    # /WARNING - TO CHANGE THE DEVICE ID and add the GPS flag/
    latestloc=Devicetype.order(created_at: :desc).where(gps:true).limit(100)
    # /JSON render to optimise with a loop/
    i=0
    hashloc=Hash.new 
    latestloc.each do |ll|
      hashloc.merge!({"p"+i.to_s => { "lat" => parse_coord(ll.data[0..7]),"lng"=>parse_coord(ll.data[8..15])}})
      i=i+1
    end
    render :json=> hashloc
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
