#include "ap_axi_sdata.h"
#include "hls_stream.h"

typedef ap_axiu<32, 1, 1, 1> pkt_t;

void isp_hls_top(hls::stream<pkt_t> &s_axis, hls::stream<pkt_t> &m_axis, int gain) {
    #pragma HLS INTERFACE axis port=s_axis
    #pragma HLS INTERFACE axis port=m_axis
    #pragma HLS INTERFACE s_axilite port=gain bundle=CTRL
    #pragma HLS INTERFACE s_axilite port=return bundle=CTRL
    static unsigned char line_buf[3][1280];
    #pragma HLS ARRAY_RESHAPE variable=line_buf complete dimension=1
    static unsigned char window[3][3];
    #pragma HLS ARRAY_PARTITION variable=window complete dimension=0
    for (int y = 0; y < 720; y++) {
        for (int x = 0; x < 1280; x++) {
            #pragma HLS PIPELINE II=1
            pkt_t curr_pkt;
            s_axis.read(curr_pkt); 
            line_buf[2][x] = line_buf[1][x];
            line_buf[1][x] = line_buf[0][x];
            unsigned int gained = (curr_pkt.data & 0xFF) * gain;
            line_buf[0][x] = (gained > 4080) ? 255 : (gained >> 4);
            for(int i = 0; i < 3; i++) {
                window[i][2] = window[i][1];
                window[i][1] = window[i][0];
                window[i][0] = line_buf[i][x];
            }
            pkt_t out_pkt = curr_pkt; 
            unsigned char R, G, B;
            unsigned char p11 = window[0][0], p12 = window[0][1], p13 = window[0][2];
            unsigned char p21 = window[1][0], p22 = window[1][1], p23 = window[1][2];
            unsigned char p31 = window[2][0], p32 = window[2][1], p33 = window[2][2];
            if (y < 2 || x < 2) {
                out_pkt.data = 0;
            } else {
                if (y % 2 == 0) { 
                    if (x % 2 == 0) { 
                        R = p22;
                        G = (p12 + p21 + p23 + p32) >> 2;
                        B = (p11 + p13 + p31 + p33) >> 2;
                    } else { 
                        R = (p21 + p23) >> 1;
                        G = p22;
                        B = (p12 + p32) >> 1;
                    }
                } else {
                    if (x % 2 == 0) { 
                        R = (p12 + p32) >> 1;
                        G = p22;
                        B = (p21 + p23) >> 1;
                    } else {
                        R = (p11 + p13 + p31 + p33) >> 2;
                        G = (p12 + p21 + p23 + p32) >> 2;
                        B = p22;
                    }
                }
                out_pkt.data = (R << 16) | (G << 8) | B;
            }

            m_axis.write(out_pkt);
        }
    }
}
