// convpng v7.0
#include <stdint.h>

uint16_t palette[256] = {
 0x0000,  // 00 :: rgb(0,0,0)
 0x7C20,  // 01 :: rgb(255,10,0)
 0x7C40,  // 02 :: rgb(255,16,0)
 0xFC40,  // 03 :: rgb(255,22,0)
 0xFC60,  // 04 :: rgb(255,27,0)
 0x7C80,  // 05 :: rgb(255,34,0)
 0x7CA0,  // 06 :: rgb(255,40,0)
 0xFCA0,  // 07 :: rgb(255,46,0)
 0xFCC0,  // 08 :: rgb(255,52,0)
 0x7CE0,  // 09 :: rgb(255,57,0)
 0x7D00,  // 10 :: rgb(255,64,0)
 0xFD00,  // 11 :: rgb(255,69,0)
 0xFD20,  // 12 :: rgb(255,76,0)
 0x7D40,  // 13 :: rgb(255,82,0)
 0x7D60,  // 14 :: rgb(255,88,0)
 0xFD60,  // 15 :: rgb(255,94,0)
 0xFD80,  // 16 :: rgb(255,100,0)
 0x7DA0,  // 17 :: rgb(255,106,0)
 0xFDA0,  // 18 :: rgb(255,111,0)
 0xFDC0,  // 19 :: rgb(255,118,0)
 0xFDE0,  // 20 :: rgb(255,124,0)
 0x7E00,  // 21 :: rgb(255,129,0)
 0x7E20,  // 22 :: rgb(255,136,0)
 0xFE20,  // 23 :: rgb(255,141,0)
 0x7E40,  // 24 :: rgb(255,147,0)
 0x7E60,  // 25 :: rgb(255,154,0)
 0xFE60,  // 26 :: rgb(255,159,0)
 0xFE80,  // 27 :: rgb(255,165,0)
 0x7EA0,  // 28 :: rgb(255,172,0)
 0x7EC0,  // 29 :: rgb(255,177,0)
 0xFEC0,  // 30 :: rgb(255,184,0)
 0xFEE0,  // 31 :: rgb(255,189,0)
 0x7F00,  // 32 :: rgb(255,196,0)
 0x7F20,  // 33 :: rgb(255,201,0)
 0xFF20,  // 34 :: rgb(255,208,0)
 0xFF40,  // 35 :: rgb(255,213,0)
 0x7F60,  // 36 :: rgb(255,219,0)
 0x7F80,  // 37 :: rgb(255,226,0)
 0xFF80,  // 38 :: rgb(255,231,0)
 0xFFA0,  // 39 :: rgb(255,237,0)
 0x7FC0,  // 40 :: rgb(255,243,0)
 0xFFC0,  // 41 :: rgb(255,248,0)
 0xFFE0,  // 42 :: rgb(253,254,0)
 0xFBE0,  // 43 :: rgb(247,255,0)
 0xF7E0,  // 44 :: rgb(241,255,0)
 0xF7E0,  // 45 :: rgb(235,255,0)
 0xF3E0,  // 46 :: rgb(229,255,0)
 0xEFE0,  // 47 :: rgb(223,255,0)
 0xEBE0,  // 48 :: rgb(217,255,0)
 0xEBE0,  // 49 :: rgb(211,255,0)
 0xE7E0,  // 50 :: rgb(205,255,0)
 0xE3E0,  // 51 :: rgb(199,255,0)
 0xDFE0,  // 52 :: rgb(193,255,0)
 0xDFE0,  // 53 :: rgb(188,255,0)
 0xDBE0,  // 54 :: rgb(181,255,0)
 0xD7E0,  // 55 :: rgb(176,255,0)
 0xD7E0,  // 56 :: rgb(169,255,0)
 0xD3E0,  // 57 :: rgb(163,255,0)
 0xCFE0,  // 58 :: rgb(158,255,0)
 0xCBE0,  // 59 :: rgb(152,255,0)
 0xCBE0,  // 60 :: rgb(145,255,0)
 0xC7E0,  // 61 :: rgb(140,255,0)
 0xC3E0,  // 62 :: rgb(133,255,0)
 0xC3E0,  // 63 :: rgb(128,255,0)
 0xBFE0,  // 64 :: rgb(121,255,0)
 0xBBE0,  // 65 :: rgb(115,255,0)
 0xB7E0,  // 66 :: rgb(109,255,0)
 0xB7E0,  // 67 :: rgb(103,255,0)
 0xB3E0,  // 68 :: rgb(98,255,0)
 0xAFE0,  // 69 :: rgb(91,255,0)
 0xABE0,  // 70 :: rgb(86,255,0)
 0xABE0,  // 71 :: rgb(79,255,0)
 0xA7E0,  // 72 :: rgb(74,255,0)
 0xA3E0,  // 73 :: rgb(68,255,0)
 0x9FE0,  // 74 :: rgb(61,255,0)
 0x9FE0,  // 75 :: rgb(56,255,0)
 0x9BE0,  // 76 :: rgb(49,255,0)
 0x97E0,  // 77 :: rgb(44,255,0)
 0x97E0,  // 78 :: rgb(38,255,0)
 0x93E0,  // 79 :: rgb(31,255,0)
 0x8FE0,  // 80 :: rgb(26,255,0)
 0x8BE0,  // 81 :: rgb(20,255,0)
 0x8BE0,  // 82 :: rgb(14,255,0)
 0x87E0,  // 83 :: rgb(8,255,0)
 0x83E0,  // 84 :: rgb(2,255,0)
 0x83E0,  // 85 :: rgb(0,255,2)
 0x83E1,  // 86 :: rgb(0,255,8)
 0x83E2,  // 87 :: rgb(0,255,13)
 0x83E2,  // 88 :: rgb(0,255,20)
 0x83E3,  // 89 :: rgb(0,255,26)
 0x83E4,  // 90 :: rgb(0,255,32)
 0x83E5,  // 91 :: rgb(0,255,38)
 0x83E5,  // 92 :: rgb(0,255,44)
 0x83E6,  // 93 :: rgb(0,255,50)
 0x83E7,  // 94 :: rgb(0,255,56)
 0x83E7,  // 95 :: rgb(0,255,61)
 0x83E8,  // 96 :: rgb(0,255,68)
 0x83E9,  // 97 :: rgb(0,255,74)
 0x83EA,  // 98 :: rgb(0,255,80)
 0x83EA,  // 99 :: rgb(0,255,86)
 0x83EB,  // 100 :: rgb(0,255,91)
 0x83EC,  // 101 :: rgb(0,255,98)
 0x83ED,  // 102 :: rgb(0,255,104)
 0x83ED,  // 103 :: rgb(0,255,110)
 0x83EE,  // 104 :: rgb(0,255,116)
 0x83EF,  // 105 :: rgb(0,255,121)
 0x83F0,  // 106 :: rgb(0,255,128)
 0x83F0,  // 107 :: rgb(0,255,133)
 0x83F1,  // 108 :: rgb(0,255,140)
 0x83F2,  // 109 :: rgb(0,255,145)
 0x83F2,  // 110 :: rgb(0,255,151)
 0x83F3,  // 111 :: rgb(0,255,158)
 0x83F4,  // 112 :: rgb(0,255,163)
 0x83F5,  // 113 :: rgb(0,255,170)
 0x83F5,  // 114 :: rgb(0,255,175)
 0x83F6,  // 115 :: rgb(0,255,181)
 0x83F7,  // 116 :: rgb(0,255,188)
 0x83F7,  // 117 :: rgb(0,255,193)
 0x83F8,  // 118 :: rgb(0,255,199)
 0x83F9,  // 119 :: rgb(0,255,205)
 0x83FA,  // 120 :: rgb(0,255,211)
 0x83FA,  // 121 :: rgb(0,255,217)
 0x83FB,  // 122 :: rgb(0,255,223)
 0x83FC,  // 123 :: rgb(0,255,229)
 0x83FD,  // 124 :: rgb(0,255,235)
 0x83FD,  // 125 :: rgb(0,255,241)
 0x83FE,  // 126 :: rgb(0,255,247)
 0x83FF,  // 127 :: rgb(0,255,253)
 0xFFFF,  // 128 :: rgb(255,255,255)
 0x03DF,  // 129 :: rgb(0,243,255)
 0x83BF,  // 130 :: rgb(0,237,255)
 0x839F,  // 131 :: rgb(0,231,255)
 0x039F,  // 132 :: rgb(0,226,255)
 0x037F,  // 133 :: rgb(0,219,255)
 0x835F,  // 134 :: rgb(0,213,255)
 0x833F,  // 135 :: rgb(0,207,255)
 0x033F,  // 136 :: rgb(0,201,255)
 0x031F,  // 137 :: rgb(0,196,255)
 0x82FF,  // 138 :: rgb(0,189,255)
 0x82DF,  // 139 :: rgb(0,184,255)
 0x02DF,  // 140 :: rgb(0,177,255)
 0x02BF,  // 141 :: rgb(0,171,255)
 0x829F,  // 142 :: rgb(0,165,255)
 0x827F,  // 143 :: rgb(0,159,255)
 0x027F,  // 144 :: rgb(0,153,255)
 0x025F,  // 145 :: rgb(0,147,255)
 0x823F,  // 146 :: rgb(0,142,255)
 0x821F,  // 147 :: rgb(0,135,255)
 0x021F,  // 148 :: rgb(0,129,255)
 0x81FF,  // 149 :: rgb(0,124,255)
 0x81DF,  // 150 :: rgb(0,118,255)
 0x01DF,  // 151 :: rgb(0,112,255)
 0x01BF,  // 152 :: rgb(0,106,255)
 0x019F,  // 153 :: rgb(0,99,255)
 0x817F,  // 154 :: rgb(0,94,255)
 0x017F,  // 155 :: rgb(0,88,255)
 0x015F,  // 156 :: rgb(0,82,255)
 0x813F,  // 157 :: rgb(0,76,255)
 0x811F,  // 158 :: rgb(0,69,255)
 0x011F,  // 159 :: rgb(0,64,255)
 0x00FF,  // 160 :: rgb(0,57,255)
 0x80DF,  // 161 :: rgb(0,52,255)
 0x80BF,  // 162 :: rgb(0,46,255)
 0x00BF,  // 163 :: rgb(0,40,255)
 0x009F,  // 164 :: rgb(0,34,255)
 0x807F,  // 165 :: rgb(0,27,255)
 0x805F,  // 166 :: rgb(0,22,255)
 0x005F,  // 167 :: rgb(0,16,255)
 0x003F,  // 168 :: rgb(0,10,255)
 0x801F,  // 169 :: rgb(0,5,255)
 0x001F,  // 170 :: rgb(1,0,255)
 0x041F,  // 171 :: rgb(6,0,255)
 0x041F,  // 172 :: rgb(12,0,255)
 0x081F,  // 173 :: rgb(18,0,255)
 0x0C1F,  // 174 :: rgb(24,0,255)
 0x101F,  // 175 :: rgb(30,0,255)
 0x101F,  // 176 :: rgb(36,0,255)
 0x141F,  // 177 :: rgb(42,0,255)
 0x181F,  // 178 :: rgb(47,0,255)
 0x1C1F,  // 179 :: rgb(54,0,255)
 0x1C1F,  // 180 :: rgb(60,0,255)
 0x201F,  // 181 :: rgb(66,0,255)
 0x241F,  // 182 :: rgb(72,0,255)
 0x241F,  // 183 :: rgb(77,0,255)
 0x281F,  // 184 :: rgb(83,0,255)
 0x2C1F,  // 185 :: rgb(90,0,255)
 0x301F,  // 186 :: rgb(95,0,255)
 0x301F,  // 187 :: rgb(102,0,255)
 0x341F,  // 188 :: rgb(108,0,255)
 0x381F,  // 189 :: rgb(113,0,255)
 0x3C1F,  // 190 :: rgb(120,0,255)
 0x3C1F,  // 191 :: rgb(125,0,255)
 0x401F,  // 192 :: rgb(132,0,255)
 0x441F,  // 193 :: rgb(137,0,255)
 0x481F,  // 194 :: rgb(144,0,255)
 0x481F,  // 195 :: rgb(149,0,255)
 0x4C1F,  // 196 :: rgb(155,0,255)
 0x501F,  // 197 :: rgb(162,0,255)
 0x501F,  // 198 :: rgb(167,0,255)
 0x541F,  // 199 :: rgb(174,0,255)
 0x581F,  // 200 :: rgb(179,0,255)
 0x581F,  // 201 :: rgb(184,0,255)
 0x5C1F,  // 202 :: rgb(192,0,255)
 0x601F,  // 203 :: rgb(197,0,255)
 0x641F,  // 204 :: rgb(204,0,255)
 0x641F,  // 205 :: rgb(209,0,255)
 0x681F,  // 206 :: rgb(215,0,255)
 0x6C1F,  // 207 :: rgb(222,0,255)
 0x701F,  // 208 :: rgb(227,0,255)
 0x701F,  // 209 :: rgb(233,0,255)
 0x741F,  // 210 :: rgb(239,0,255)
 0x781F,  // 211 :: rgb(245,0,255)
 0x7C1F,  // 212 :: rgb(251,0,255)
 0x7C1F,  // 213 :: rgb(254,0,251)
 0x7C1E,  // 214 :: rgb(255,0,245)
 0x7C1D,  // 215 :: rgb(255,0,240)
 0x7C1C,  // 216 :: rgb(255,0,233)
 0x7C1C,  // 217 :: rgb(255,0,227)
 0x7C1B,  // 218 :: rgb(255,0,222)
 0x7C1A,  // 219 :: rgb(255,0,215)
 0x7C19,  // 220 :: rgb(255,0,209)
 0x7C19,  // 221 :: rgb(255,0,204)
 0x7C18,  // 222 :: rgb(255,0,197)
 0x7C17,  // 223 :: rgb(255,0,192)
 0x7C16,  // 224 :: rgb(255,0,185)
 0x7C16,  // 225 :: rgb(255,0,179)
 0x7C15,  // 226 :: rgb(255,0,173)
 0x7C14,  // 227 :: rgb(255,0,167)
 0x7C14,  // 228 :: rgb(255,0,162)
 0x7C13,  // 229 :: rgb(255,0,155)
 0x7C12,  // 230 :: rgb(255,0,150)
 0x7C11,  // 231 :: rgb(255,0,143)
 0x7C11,  // 232 :: rgb(255,0,137)
 0x7C10,  // 233 :: rgb(255,0,132)
 0x7C0F,  // 234 :: rgb(255,0,125)
 0x7C0F,  // 235 :: rgb(255,0,120)
 0x7C0E,  // 236 :: rgb(255,0,113)
 0x7C0D,  // 237 :: rgb(255,0,108)
 0x7C0C,  // 238 :: rgb(255,0,102)
 0x7C0C,  // 239 :: rgb(255,0,95)
 0x7C0B,  // 240 :: rgb(255,0,90)
 0x7C0A,  // 241 :: rgb(255,0,84)
 0x7C09,  // 242 :: rgb(255,0,78)
 0x7C09,  // 243 :: rgb(255,0,72)
 0x7C08,  // 244 :: rgb(255,0,65)
 0x7C07,  // 245 :: rgb(255,0,60)
 0x7C07,  // 246 :: rgb(255,0,54)
 0x7C06,  // 247 :: rgb(255,0,48)
 0x7C05,  // 248 :: rgb(255,0,42)
 0x7C04,  // 249 :: rgb(255,0,36)
 0x7C04,  // 250 :: rgb(255,0,30)
 0x7C03,  // 251 :: rgb(255,0,24)
 0x7C02,  // 252 :: rgb(255,0,18)
 0x7C01,  // 253 :: rgb(255,0,12)
 0x7C01,  // 254 :: rgb(255,0,6)
 0x7C00,  // 255 :: rgb(255,0,4)
};