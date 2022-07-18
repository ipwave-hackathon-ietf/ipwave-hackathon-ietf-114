// 
//                           SimuLTE
// 
// This file is part of a software released under the license included in file
// "license.pdf". This license can be also found at http://www.ltesimulator.com/
// The above file and the present reference are part of the software itself, 
// and cannot be removed from it.
// 


package lte.corenetwork.nodes.cars;
import inet.applications.contract.ITCPApp;
import inet.applications.contract.IUDPApp;
import inet.mobility.contract.IMobility;
import inet.networklayer.common.InterfaceTable;
import inet.networklayer.contract.IRoutingTable;
import inet.networklayer.contract.INetworkLayer;
import inet.networklayer.configurator.ipv4.HostAutoConfigurator;
import inet.transportlayer.tcp.TCP;
import inet.transportlayer.udp.UDP;
import lte.stack.phy.ILteNic;
import lte.stack.phy.LteNicUe;
import lte.stack.phy.LteNicUeD2D;
import lte.stack.phy.LteNicVUeMode4;
//Bien Aime
import inet.node.ipv6.StandardHost6;
import inet.networklayer.configurator.ipv6.FlatNetworkConfigurator6;
import lte.apps.mode4App.*;




// 
// Car Module
//
module CarIPv6prev extends StandardHost6
{
    parameters:
        @networkNode();
		@display("i=veins/node/car;bgb=400,518");
		
        //# Mobility
//   		string mobilityType = default("VeinsInetMobility");

//		Bien Aime
        hasTcp = true;
        forwarding = true;
        string applType; //type of the application layer
        bool hasAppl = default(false);
        ipv6.xMIPv6Support = true;
        ipv6.mipv6support.isMobileNode = true; //is Mobile Node
    	ipv6.mipv6support.isHomeAgent = false; //is Home Agent
        

        //# Node specs
        string nodeType = "UE";  // DO NOT CHANGE
        int masterId = default(0); // Not yet removed from SimuLTE for Mode 4 simulations
        int macNodeId = default(0); // TODO: this is not a real parameter
        int macCellId = default(0); // TODO: this is not a real parameter


        //# D2D capability
        bool d2dCapable = default(false);
        bool mode4D2D = default(false);
        
        // Check if the car is D2D, if it is further check if it's mode4, otherwise it's a simple Ue
        string nicType = d2dCapable ? mode4D2D ? "LteNicUeMode4D2D" : "LteNicUeD2D" : "LteNicUe";

        //# Network Layer specs
        *.interfaceTableModule = default(absPath(".interfaceTable"));
        *.routingTableModule = default(absPath(".routingTable"));

    submodules:
        // network layer
//        networkLayer: <networkLayerType> like INetworkLayer {
//            parameters:
//                @display("p=250,258");
//        }
//        configurator: HostAutoConfigurator {
//            @display("p=49.068,22.968");
//        }
//        BAM
        appl: <applType> like lte.apps.mode4App.Mode4BaseApp {
            parameters:
                @display("p=60,50");
        }
        lteNic: <nicType> like ILteNic {
            nodeType = nodeType;
            d2dCapable = d2dCapable;
            @display("p=250,407");
        }
        

        configurator: FlatNetworkConfigurator6 {
            @display("is=s;p=709.784,342.152");
        }
        
  
    connections allowunconnected:
//        //# 
//        //# Internal TCP/UDP applications connections with IP stack
//        //#
//
//        for i=0..numTcpApps-1 {
//            tcpApp[i].tcpOut --> tcp.appIn++;
//            tcpApp[i].tcpIn <-- tcp.appOut++;
//        }
//
//        tcp.ipOut --> networkLayer.transportIn++ if numTcpApps>0;
//        tcp.ipIn <-- networkLayer.transportOut++ if numTcpApps>0;
//
//        for i=0..numUdpApps-1 {
//            udpApp[i].udpOut --> udp.appIn++;
//            udpApp[i].udpIn <-- udp.appOut++;
//        }
//
//        udp.ipOut --> networkLayer.transportIn++ if numUdpApps>0;
//        udp.ipIn <-- networkLayer.transportOut++ if numUdpApps>0;
//       
//        for i=0..sizeof(radioIn)-1 {    
//			lteNic.radioIn <-- radioIn[i];
//        }
//
//        networkLayer.ifOut++ --> lteNic.upperLayerIn;
//        networkLayer.ifIn++ <-- lteNic.upperLayerOut;
        
            //# 
        //# Internal TCP/UDP applications connections with IP stack
        //#

        lteNic.upperLayerOut --> appl.lowerGateIn;
        lteNic.upperLayerIn <-- appl.lowerGateOut;
		for i=0..sizeof(radioIn)-1 {    
			lteNic.radioIn <-- radioIn[i];
		}

//        lteNic.radioIn <-- radioIn;
}
