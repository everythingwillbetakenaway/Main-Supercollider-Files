(
var folder;
//Supernova Node ID
~novaAcid = ParGroup.new;
//MASIBO
~abcBD = Bus.audio(s,1);
~abcCYM = Bus.audio(s,1);
~abcHH = Bus.audio(s,1);
~abcPRC = Bus.audio(s,1);
~abcSD = Bus.audio(s,1);
~abcCLP = Bus.audio(s,1);
~abcTOM = Bus.audio(s,1);
~abcEFX = Bus.audio(s,1);
~effektbusBD = Bus.audio(s,1);
~effektbusCYM = Bus.audio(s,1);
~effektbusHH = Bus.audio(s,1);
~effektbusPRC = Bus.audio(s,1);
~effektbusSD = Bus.audio(s,1);
~effektbusCLP = Bus.audio(s,1);
~effektbusTOM = Bus.audio(s,1);
~effektbusEFX = Bus.audio(s,1);
//ETNA
~abc1etna = Bus.audio(s,1);
~abc2etna = Bus.audio(s,1);
~abc3etna = Bus.audio(s,1);
~abc4etna = Bus.audio(s,1);
~abc5etna = Bus.audio(s,1);
~abc6etna = Bus.audio(s,1);
~effektbus1etna = Bus.audio(s,1);
~effektbus2etna = Bus.audio(s,1);
~effektbus3etna = Bus.audio(s,1);
~effektbus4etna = Bus.audio(s,1);
~effektbus5etna = Bus.audio(s,1);
~effektbus6etna = Bus.audio(s,1);
//MASIBO
folder = PathName.new(("z-SampleStorage/DRUMBACK/1BD/".resolveRelative).asAbsolutePath);
folder.entries.do({
	arg path;
	~drumBD = ~drumBD.add(Buffer.read(s, path.fullPath));
});
folder = PathName.new(("z-SampleStorage/DRUMBACK/2CYM/".resolveRelative).asAbsolutePath);
folder.entries.do({
	arg path;
	~drumCYM = ~drumCYM.add(Buffer.read(s, path.fullPath));
});
folder = PathName.new(("z-SampleStorage/DRUMBACK/3HH/".resolveRelative).asAbsolutePath);
folder.entries.do({
	arg path;
	~drumHH = ~drumHH.add(Buffer.read(s, path.fullPath));
});
folder = PathName.new(("z-SampleStorage/DRUMBACK/4PRC/".resolveRelative).asAbsolutePath);
folder.entries.do({
	arg path;
	~drumPRC = ~drumPRC.add(Buffer.read(s, path.fullPath));
});
folder = PathName.new(("z-SampleStorage/DRUMBACK/5SD/".resolveRelative).asAbsolutePath);
folder.entries.do({
	arg path;
	~drumSD = ~drumSD.add(Buffer.read(s, path.fullPath));
});
folder = PathName.new(("z-SampleStorage/DRUMBACK/6CLP/".resolveRelative).asAbsolutePath);
folder.entries.do({
	arg path;
	~drumCLP = ~drumCLP.add(Buffer.read(s, path.fullPath));
});
folder = PathName.new(("z-SampleStorage/DRUMBACK/7TOM/".resolveRelative).asAbsolutePath);
folder.entries.do({
	arg path;
	~drumTOM = ~drumTOM.add(Buffer.read(s, path.fullPath));
});
folder = PathName.new(("z-SampleStorage/DRUMBACK/8EFX/".resolveRelative).asAbsolutePath);
folder.entries.do({
	arg path;
	~drumEFX = ~drumEFX.add(Buffer.read(s, path.fullPath));
});



/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
//CH1
folder = PathName.new(("z-SampleStorage/SamplesfFinalConcertNy/".resolveRelative).asAbsolutePath);
folder.entries.do({
	arg path;
	~blls = ~blls.add(Buffer.read(s, path.fullPath));
});
//MAKE NOISE
folder = PathName.new(("z-SampleStorage/samplesformakenoise/".resolveRelative).asAbsolutePath);
folder.entries.do({
	arg path;
	~makeNoise = ~makeNoise.add(Buffer.read(s, path.fullPath));
});
//ETNA
/*
Routine { 3.wait;
	folder = PathName.new(("z-SampleStorage/SA909_Samples/SA909_BD/".resolveRelative).asAbsolutePath);
	folder.entries.do({
		arg path;
		~drum1 = ~drum1.add(Buffer.read(s, path.fullPath));
	});
	folder = PathName.new(("z-SampleStorage/SA909_Samples/SA909_CYM/".resolveRelative).asAbsolutePath);
	folder.entries.do({
		arg path;
		~drum2 = ~drum2.add(Buffer.read(s, path.fullPath));
	});
	folder = PathName.new(("z-SampleStorage/SA909_Samples/SA909_HH/".resolveRelative).asAbsolutePath);
	folder.entries.do({
		arg path;
		~drum3 = ~drum3.add(Buffer.read(s, path.fullPath));
	});
	folder = PathName.new(("z-SampleStorage/SA909_Samples/SA909_Perc/".resolveRelative).asAbsolutePath);
	folder.entries.do({
		arg path;
		~drum4 = ~drum4.add(Buffer.read(s, path.fullPath));
	});
	folder = PathName.new(("z-SampleStorage/SA909_Samples/SA909_SD/".resolveRelative).asAbsolutePath);
	folder.entries.do({
		arg path;
		~drum5 = ~drum5.add(Buffer.read(s, path.fullPath));
	});
	folder = PathName.new(("z-SampleStorage/SA909_Samples/SA909_Tom/".resolveRelative).asAbsolutePath);
	folder.entries.do({
		arg path;
		~drum6 = ~drum6.add(Buffer.read(s, path.fullPath));
	});
}.play;*/
)


