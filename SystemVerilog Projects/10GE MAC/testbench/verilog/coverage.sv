class coverage;
  packet covpacket;
  
  covergroup switchcov;
    src_addr: coverpoint covpacket.src_addr{
                                            bins unicast= {[48'h0:48'h00FFFFFFFFFF]};
                                            bins multicast= {[48'h010000000000:48'h01FFFFFFFFFF]};
                                            bins broadcast= {48'hFFFFFFFFFFFF};
                                            bins others = default;
						}
    dst_addr: coverpoint covpacket.dst_addr{
                                            bins unicast= {[48'h0:48'h00FFFFFFFFFF]};
                                            bins multicast= {[48'h010000000000:48'h01FFFFFFFFFF]};
                                            bins broadcast= {48'hFFFFFFFFFFFF};
                                            bins others = default;
                                                }
    ether_type: coverpoint covpacket.ether_type{
                                            bins ipv4   = { 16'h0800 };
                                            bins arp    = { 16'h0806 };
                                            bins ipv6   = { 16'h86DD };
                                                }
    payload: coverpoint covpacket.payload.size(){
                                            bins undersize_packet = {[0:46 ]};
                                            bins normal_packet = {[46:1500]};
                                            bins jumbo_packet = {[1500:9000]};
                                                }
    ipg: coverpoint covpacket.ipg{ 
                                            bins zero_ipg = {0};
                                            bins small_ipg = {[10:20]};
                                            bins medium_ipg = {[20:40]};
                                            bins large_ipg = {[40:50]};
                                                }  
  endgroup

  function new();
    switchcov = new();
  endfunction

  task collect_coverage(input packet pkt_from_drv);
    this.covpacket = pkt_from_drv;
    switchcov.sample();
  endtask
endclass
