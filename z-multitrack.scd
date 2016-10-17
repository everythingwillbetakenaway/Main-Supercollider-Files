(
var abc;
abc = "/Users/EmanTnuocca/Desktop/" ++ "!" ++ (Date.getDate.format("%Y-%d-%m-%Hh%Mm%Ss")).asString ++ "/";
File.mkdir(abc);
if ( ~test_DrumSmpl1 == 1,
	{
		~buf_DrumSmpl1= Buffer.alloc(s, 65536, 1);
		~buf_DrumSmpl1.write(abc ++ "DrumSmpl1.aiff", "aiff", "int16", 0, 0, true);
		~trk_DrumSmpl1 = Synth(\DrumSmpl1Diskout, ["bufnum", ~buf_DrumSmpl1]);
},);
if ( ~test_DrumSmpl2 == 1,
	{
		~buf_DrumSmpl2 = Buffer.alloc(s, 65536, 1);
		~buf_DrumSmpl2.write(abc ++ "DrumSmpl2.aiff", "aiff", "int16", 0, 0, true);
		~trk_DrumSmpl2 = Synth(\DrumSmpl2Diskout, ["bufnum", ~buf_DrumSmpl2]);
},);
if ( ~test_DrumSmpl3 == 1,
	{
		~buf_DrumSmpl3= Buffer.alloc(s, 65536, 1);
		~buf_DrumSmpl3.write(abc ++ "DrumSmpl3.aiff", "aiff", "int16", 0, 0, true);
		~trk_DrumSmpl3 = Synth(\DrumSmpl3Diskout, ["bufnum", ~buf_DrumSmpl3]);
},);
if ( ~test_DrumSmpl4 == 1,
	{
		~buf_DrumSmpl4= Buffer.alloc(s, 65536, 1);
		~buf_DrumSmpl4.write(abc ++ "DrumSmpl4.aiff", "aiff", "int16", 0, 0, true);
		~trk_DrumSmpl4 = Synth(\DrumSmpl4Diskout, ["bufnum", ~buf_DrumSmpl4]);
},);
if ( ~test_DrumSmpl5 == 1,
	{
		~buf_DrumSmpl5= Buffer.alloc(s, 65536, 1);
		~buf_DrumSmpl5.write(abc ++ "DrumSmpl5.aiff", "aiff", "int16", 0, 0, true);
		~trk_DrumSmpl5 = Synth(\DrumSmpl5Diskout, ["bufnum", ~buf_DrumSmpl5]);
},);
if ( ~test_DrumSmpl6 == 1,
	{
		~buf_DrumSmpl6= Buffer.alloc(s, 65536, 1);
		~buf_DrumSmpl6.write(abc ++ "DrumSmpl6.aiff", "aiff", "int16", 0, 0, true);
		~trk_DrumSmpl6 = Synth(\DrumSmpl6Diskout, ["bufnum", ~buf_DrumSmpl6]);
},);
if ( ~test_Massaka == 1,
	{
		~buf_Massaka= Buffer.alloc(s, 65536, 1);
		~buf_Massaka.write(abc ++ "Massaka.aiff", "aiff", "int16", 0, 0, true);
		~trk_Massaka = Synth(\MassakaDiskout, ["bufnum", ~buf_Massaka]);
},);
if ( ~test_Sumanguru == 1,
	{
		~buf_Sumanguru= Buffer.alloc(s, 65536, 1);
		~buf_Sumanguru.write(abc ++ "Sumanguru.aiff", "aiff", "int24", 0, 0, true);
		~trk_Sumanguru = Synth(\SumanguruDiskout, ["bufnum", ~buf_Sumanguru]);
},);
if ( ~test_Acid == 1,
	{
		~buf_Acid= Buffer.alloc(s, 65536, 1);
		~buf_Acid.write(abc ++ "Acid.aiff", "aiff", "int16", 0, 0, true);
		~trk_Acid = Synth(\AcidDiskout, ["bufnum", ~buf_Acid]);
},);
if ( ~test_P5pwm == 1,
	{
		~buf_P5pwm= Buffer.alloc(s, 65536, 1);
		~buf_P5pwm.write(abc ++ "P5pwm.aiff", "aiff", "int16", 0, 0, true);
		~trk_P5pwm = Synth(\P5pwmDiskout, ["bufnum", ~buf_P5pwm]);
},);
if ( ~test_Lumbricost == 1,
	{
		~buf_Lumbricost= Buffer.alloc(s, 65536, 1);
		~buf_Lumbricost.write(abc ++ "Lumbricost.aiff", "aiff", "int16", 0, 0, true);
		~trk_Lumbricost = Synth(\LumbricostDiskout, ["bufnum", ~buf_Lumbricost]);
},);
if ( ~test_SOSkick == 1,
	{
		~buf_SOSkick= Buffer.alloc(s, 65536, 1);
		~buf_SOSkick.write(abc ++ "SOSkick.aiff", "aiff", "int16", 0, 0, true);
		~trk_SOSkick = Synth(\SOSkickDiskout, ["bufnum", ~buf_SOSkick]);
},);
if ( ~test_SOShats == 1,
	{
		~buf_SOShats= Buffer.alloc(s, 65536, 1);
		~buf_SOShats.write(abc ++ "SOShats.aiff", "aiff", "int16", 0, 0, true);
		~trk_SOShats = Synth(\SOShatsDiskout, ["bufnum", ~buf_SOShats]);
},);
if ( ~test_SOSsnare == 1,
	{
		~buf_SOSsnare= Buffer.alloc(s, 65536, 1);
		~buf_SOSsnare.write(abc ++ "SOSsnare.aiff", "aiff", "int16", 0, 0, true);
		~trk_SOSsnare = Synth(\SOSsnareDiskout, ["bufnum", ~buf_SOSsnare]);
},);
if ( ~test_SOStom == 1,
	{
		~buf_SOStom= Buffer.alloc(s, 65536, 1);
		~buf_SOStom.write(abc ++ "SOStom.aiff", "aiff", "int16", 0, 0, true);
		~trk_SOStom = Synth(\SOStomDiskout, ["bufnum", ~buf_SOStom]);
},);
if ( ~test_Etna1 == 1,
	{
		~buf_Etna1= Buffer.alloc(s, 65536, 1);
		~buf_Etna1.write(abc ++ "Etna1.aiff", "aiff", "int16", 0, 0, true);
		~trk_Etna1 = Synth(\Etna1Diskout, ["bufnum", ~buf_Etna1]);
},);
if ( ~test_Etna2 == 1,
	{
		~buf_Etna2= Buffer.alloc(s, 65536, 1);
		~buf_Etna2.write(abc ++ "Etna2.aiff", "aiff", "int16", 0, 0, true);
		~trk_Etna2 = Synth(\Etna2Diskout, ["bufnum", ~buf_Etna2]);
},);
if ( ~test_Etna3 == 1,
	{
		~buf_Etna3= Buffer.alloc(s, 65536, 1);
		~buf_Etna3.write(abc ++ "Etna3.aiff", "aiff", "int16", 0, 0, true);
		~trk_Etna3 = Synth(\Etna3Diskout, ["bufnum", ~buf_Etna3]);
},);
if ( ~test_Etna4 == 1,
	{
		~buf_Etna4= Buffer.alloc(s, 65536, 1);
		~buf_Etna4.write(abc ++ "Etna4.aiff", "aiff", "int16", 0, 0, true);
		~trk_Etna4 = Synth(\Etna4Diskout, ["bufnum", ~buf_Etna4]);
},);
if ( ~test_Etna5 == 1,
	{
		~buf_Etna5= Buffer.alloc(s, 65536, 1);
		~buf_Etna5.write(abc ++ "Etna5.aiff", "aiff", "int16", 0, 0, true);
		~trk_Etna5 = Synth(\Etna5Diskout, ["bufnum", ~buf_Etna5]);
},);
if ( ~test_Etna6 == 1,
	{
		~buf_Etna6= Buffer.alloc(s, 65536, 1);
		~buf_Etna6.write(abc ++ "Etna6.aiff", "aiff", "int16", 0, 0, true);
		~trk_Etna6 = Synth(\Etna6Diskout, ["bufnum", ~buf_Etna6]);
},);
if ( ~test_DPG1 == 1,
	{
		~buf_DPG1= Buffer.alloc(s, 65536, 1);
		~buf_DPG1.write(abc ++ "DPG1.aiff", "aiff", "int16", 0, 0, true);
		~trk_DPG1 = Synth(\DPG1Diskout, ["bufnum", ~buf_DPG1]);
},);
if ( ~test_DPG2 == 1,
	{
		~buf_DPG2= Buffer.alloc(s, 65536, 1);
		~buf_DPG2.write(abc ++ "DPG2.aiff", "aiff", "int16", 0, 0, true);
		~trk_DPG2 = Synth(\DPG2Diskout, ["bufnum", ~buf_DPG2]);
},);
if ( ~test_Appajax2000 == 1,
	{
		~buf_Appajax2000= Buffer.alloc(s, 65536, 1);
		~buf_Appajax2000.write(abc ++ "Appajax2000.aiff", "aiff", "int16", 0, 0, true);
		~trk_Appajax2000 = Synth(\Appajax2000Diskout, ["bufnum", ~buf_Appajax2000]);
},);
if ( ~test_Senjin == 1,
	{
		~buf_Senjin = Buffer.alloc(s, 65536, 1);
		~buf_Senjin.write(abc ++ "Senjin.aiff", "aiff", "int16", 0, 0, true);
		~trk_Senjin = Synth(\SenjinDiskout, ["bufnum", ~buf_Senjin]);
},);
if ( ~test_MasiboBD == 1,///
	{
		~buf_MasiboBD = Buffer.alloc(s, 65536, 1);
		~buf_MasiboBD.write(abc ++ "MasiboBD.aiff", "aiff", "int16", 0, 0, true);
		~trk_MasiboBD = Synth(\MasiboBDDiskout, ["bufnum", ~buf_MasiboBD]);
},);
if ( ~test_MasiboCYM == 1,
	{
		~buf_MasiboCYM = Buffer.alloc(s, 65536, 1);
		~buf_MasiboCYM.write(abc ++ "MasiboCYM.aiff", "aiff", "int16", 0, 0, true);
		~trk_MasiboCYM = Synth(\MasiboCYMDiskout, ["bufnum", ~buf_MasiboCYM]);
},);
if ( ~test_MasiboHH == 1,
	{
		~buf_MasiboHH = Buffer.alloc(s, 65536, 1);
		~buf_MasiboHH.write(abc ++ "MasiboHH.aiff", "aiff", "int16", 0, 0, true);
		~trk_MasiboHH = Synth(\MasiboHHDiskout, ["bufnum", ~buf_MasiboHH]);
},);
if ( ~test_MasiboPRC == 1,
	{
		~buf_MasiboPRC = Buffer.alloc(s, 65536, 1);
		~buf_MasiboPRC.write(abc ++ "MasiboPRC.aiff", "aiff", "int16", 0, 0, true);
		~trk_MasiboPRC = Synth(\MasiboPRCDiskout, ["bufnum", ~buf_MasiboPRC]);
},);
if ( ~test_MasiboSD == 1,
	{
		~buf_MasiboSD = Buffer.alloc(s, 65536, 1);
		~buf_MasiboSD.write(abc ++ "MasiboSD.aiff", "aiff", "int16", 0, 0, true);
		~trk_MasiboSD = Synth(\MasiboSDDiskout, ["bufnum", ~buf_MasiboSD]);
},);
if ( ~test_MasiboCLP == 1,
	{
		~buf_MasiboCLP = Buffer.alloc(s, 65536, 1);
		~buf_MasiboCLP.write(abc ++ "MasiboCLP.aiff", "aiff", "int16", 0, 0, true);
		~trk_MasiboCLP = Synth(\MasiboCLPDiskout, ["bufnum", ~buf_MasiboCLP]);
},);
if ( ~test_MasiboTOM == 1,
	{
		~buf_MasiboTOM = Buffer.alloc(s, 65536, 1);
		~buf_MasiboTOM.write(abc ++ "MasiboTOM.aiff", "aiff", "int16", 0, 0, true);
		~trk_MasiboTOM = Synth(\MasiboTOMDiskout, ["bufnum", ~buf_MasiboTOM]);
},);
if ( ~test_MasiboEFX == 1,
	{
		~buf_MasiboEFX = Buffer.alloc(s, 65536, 1);
		~buf_MasiboEFX.write(abc ++ "MasiboEFX.aiff", "aiff", "int16", 0, 0, true);
		~trk_MasiboEFX = Synth(\MasiboEFXDiskout, ["bufnum", ~buf_MasiboEFX]);
},);
if ( ~test_Manchun == 1,
	{
		~buf_Manchun = Buffer.alloc(s, 65536, 1);
		~buf_Manchun.write(abc ++ "Manchun.aiff", "aiff", "int16", 0, 0, true);
		~trk_Manchun = Synth(\ManchunDiskout, ["bufnum", ~buf_Manchun]);
},);
if ( ~test_Inferno == 1,
	{
		~buf_Inferno = Buffer.alloc(s, 65536, 1);
		~buf_Inferno.write(abc ++ "Inferno.aiff", "aiff", "int16", 0, 0, true);
		~trk_Inferno = Synth(\InfernoDiskout, ["bufnum", ~buf_Inferno]);
},);
)