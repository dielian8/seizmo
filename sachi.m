function [varargout]=sachi(version)
%SACHI    Returns SAC header information for read/modify/write operations
%
%    Description: Provides all information necessary to read/modify/write 
%     the specified version of a SAC file.
%    
%    Usage:    valid_versions=sachi();
%              header_info=sachi(version);
%
%    See also:  gv, ch, lh, gh, glgc, genum, genumdesc, doubleit,
%               fixdelta, rh, rpdw, rdata, rsac, bsac, wh, wsac,
%               chkhdr, sacsize

% check nargin
error(nargchk(0,1,nargin))

% no args - return valid versions
valid=[6 101 102 200 201 202];
if(nargin==0)
    varargout{1}=valid;
    return;
end

% check for invalid version
if(~any(valid==version))
    error('Header version invalid: %d!',version)
end

% SAC version 6 header setup
if(any(version==[6 101 102 200 201 202]))
    header.version=6;
    header.numfields=133;
    header.size=302;
    header.store='single';
    
    header.data.startbyte=632;
    header.data.store='single';
    header.data.bytesize=4;
    
    header.types={'real' 'int' 'enum' 'lgc' 'char'};
    header.ntype={'real' 'int' 'enum' 'lgc'};
    header.stype={'char'};
    
    header.undef.stype='-12345';
    header.undef.ntype=-12345;
    
    header.true=1;
    header.false=0;
    
    header.grp.t.min=0;
    header.grp.t.max=9;
    header.grp.kt.min=0;
    header.grp.kt.max=9;
    header.grp.user.min=0;
    header.grp.user.max=9;
    header.grp.kuser.min=0;
    header.grp.kuser.max=2;
    header.grp.resp.min=0;
    header.grp.resp.max=9;
    
    header.real.startbyte=0;
    header.real.store='single';
    header.real.bytesize=4;
    header.real.numfields=70;
    header.real.size=70;
    header.real.minpos=1;
    header.real.maxpos=70;
    header.real.pos=struct('delta',1,'depmin',2,'depmax',3,'scale',4,...
        'odelta',5,'b',6,'e',7,'o',8,'a',9,'fmt',10,'t0',11,'t1',12,...
        't2',13,'t3',14,'t4',15,'t5',16,'t6',17,'t7',18,'t8',19,'t9',20,...
        'f',21,'resp0',22,'resp1',23,'resp2',24,'resp3',25, 'resp4',26,...
        'resp5',27,'resp6',28,'resp7',29,'resp8',30,'resp9',31,'stla',32,...
        'stlo',33,'stel',34,'stdp',35,'evla',36,'evlo',37,'evel',38,...
        'evdp',39,'mag',40,'user0',41,'user1',42,'user2',43,'user3',44,...
        'user4',45,'user5',46,'user6',47,'user7',48,'user8',49,'user9',50,...
        'dist',51,'az',52,'baz',53,'gcarc',54,'sb',55,'sdelta',56,...
        'depmen',57,'cmpaz',58,'cmpinc',59,'xminimum',60,'xmaximum',61,...
        'yminimum',62,'ymaximum',63,'unused6',64,'unused7',65,'unused8',66,...
        'unused9',67,'unused10',68,'unused11',69,'unused12',70);
    
    header.int.startbyte=280;
    header.int.store='int32';
    header.int.bytesize=4;
    header.int.numfields=15;
    header.int.size=15;
    header.int.minpos=71;
    header.int.maxpos=85;
    header.int.pos=struct('nzyear',71,...
        'nzjday',72,'nzhour',73,'nzmin',74,'nzsec',75,'nzmsec',76,...
        'nvhdr',77,'norid',78,'nevid',79,'npts',80,'nspts',81,'nwfid',82,...
        'nxsize',83,'nysize',84,'unused15',85);
    
    header.enum.startbyte=340;
    header.enum.store='int32';
    header.enum.bytesize=4;
    header.enum.numfields=20;
    header.enum.size=20;
    header.enum.minpos=86;
    header.enum.maxpos=105;
    header.enum.minval=0;
    header.enum.maxval=97;
    header.enum.pos=struct('iftype',86,'idep',87,'iztype',88,'unused16',89,...
        'iinst',90,'istreg',91,'ievreg',92,'ievtyp',93,'iqual',94,...
        'isynth',95,'imagtyp',96,'imagsrc',97,'unused19',98,'unused20',99,...
        'unused21',100,'unused22',101,'unused23',102,'unused24',103,...
        'unused25',104,'unused26',105);
    
    header.enum.id={'ireal' 'itime' 'irlim' 'iamph' 'ixy' 'iunkn' 'idisp' ...
        'ivel' 'iacc' 'ib' 'iday' 'io' 'ia' 'it0' 'it1' 'it2' ...
        'it3' 'it4' 'it5' 'it6' 'it7' 'it8' 'it9' 'iradnv' ...
        'itannv' 'iradev' 'itanev' 'inorth' 'ieast' 'ihorza' 'idown' ...
        'iup' 'illlbb' 'iwwsn1' 'iwwsn2' 'ihglp' 'isro' 'inucl' ...
        'ipren' 'ipostn' 'iquake' 'ipreq' 'ipostq' 'ichem' 'iother' ...
        'igood' 'iglch' 'idrop' 'ilowsn' 'irldta' 'ivolts' 'ixyz' ...
        'imb' 'ims' 'iml' 'imw' 'imd' 'imx' 'ineic' 'ipdeq' ...
        'ipdew' 'ipde' 'iisc' 'ireb' 'iusgs' 'ibrk' 'icaltech' ...
        'illnl' 'ievloc' 'ijsop' 'iuser' 'iunknown' 'iqb' 'iqb1' ...
        'iqb2' 'iqbx' 'iqmt' 'ieq' 'ieq1' 'ieq2' 'ime' 'iex' ...
        'inu' 'inc' 'io_' 'il' 'ir' 'it' 'iu' 'ieq3' 'ieq0' ...
        'iex0' 'iqc' 'iqb0' 'igey' 'ilit' 'imet' 'iodor'};
    
    header.enum.val=struct('ireal',0,'itime',1,'irlim',2,'iamph',3,'ixy',4,...
        'iunkn',5,'idisp',6,'ivel',7,'iacc',8,'ib',9,'iday',10,'io',11,...
        'ia',12,'it0',13,'it1',14,'it2',15,'it3',16,'it4',17,'it5',18,...
        'it6',19,'it7',20,'it8',21,'it9',22,'iradnv',23,'itannv',24,...
        'iradev',25,'itanev',26,'inorth',27,'ieast',28,'ihorza',29,...
        'idown',30,'iup',31,'illlbb',32,'iwwsn1',33,'iwwsn2',34,'ihglp',35,...
        'isro',36,'inucl',37,'ipren',38,'ipostn',39,'iquake',40,'ipreq',41,...
        'ipostq',42,'ichem',43,'iother',44,'igood',45,'iglch',46,...
        'idrop',47,'ilowsn',48,'irldta',49,'ivolts',50,'ixyz',51,'imb',52,...
        'ims',53,'iml',54,'imw',55,'imd',56,'imx',57,'ineic',58,'ipdeq',59,...
        'ipdew',60,'ipde',61,'iisc',62,'ireb',63,'iusgs',64,'ibrk',65,...
        'icaltech',66,'illnl',67,'ievloc',68,'ijsop',69,'iuser',70,...
        'iunknown',71,'iqb',72,'iqb1',73,'iqb2',74,'iqbx',75,'iqmt',76,...
        'ieq',77,'ieq1',78,'ieq2',79,'ime',80,'iex',81,'inu',82,'inc',83,...
        'io_',84,'il',85,'ir',86,'it',87,'iu',88,'ieq3',89,'ieq0',90,...
        'iex0',91,'iqc',92,'iqb0',93,'igey',94,'ilit',95,'imet',96,...
        'iodor',97);
    
    header.enum.desc={'Undocumented' ...
        ...% iftype
        'Time Series File' 'Spectral File-Real/Imag' ...
        'Spectral File-Ampl/Phase' 'General X vs Y file' ...
        ...% idep
        'Unknown' 'Displacement (nm)' ...
        'Velocity (nm/sec)' 'Acceleration (cm/sec/sec)' ...
        ...% iztype
        'Begin Time' 'GMT Day' 'Event Origin Time' 'First Arrival Time' ...
        'User Defined Time Pick 0' 'User Defined Time Pick 1' ...
        'User Defined Time Pick 2' 'User Defined Time Pick 3' ...
        'User Defined Time Pick 4' 'User Defined Time Pick 5' ...
        'User Defined Time Pick 6' 'User Defined Time Pick 7' ...
        'User Defined Time Pick 8' 'User Defined Time Pick 9' ...
        ...% iinst
        'Radial (NTS)' 'Tangential (NTS)' 'Radial (Event)' ... 
        'Tangential (Event)' 'North Positive' 'East Positive' ...
        'Horizontal (ARB)' 'Down Positive' 'Up Positive' ...
        'LLL Broadband' 'WWSN 15-100' 'WWSN 30-100' ...
        'High Gain Long Period' 'SRO' ...
        ...% ievtyp
        'Nuclear Event' 'Nuclear Pre-Shot Event' ...
        'Nuclear Post-Shot Event' 'Earthquake' 'Foreshock' ...
        'Aftershock' 'Chemical Explosion' 'Other' ...
        ...% iqual
        'Good' 'Glitches' 'Dropouts' 'Low Signal to Noise Ratio' ...
        ...% isynth
        'Real Data' ...
        ...% idep (cont)
        'Velocity (Volts)' ...
        ...% iftype (cont)
        'General XYZ (3-D) file' ...
        ...% imagtyp
        'Body Wave Magnitude (Mb)' 'Surface Wave Magnitude (Ms)' ...
        'Local Magnitude (ML)' 'Moment Magnitude (Mw)' ...
        'Duration Magnitude (Md)' 'User Defined Magnitude' ...
        ...% imagsrc
        'NEIC' 'PDEQ' 'PDEW' 'PDE' 'ISC' 'REB' 'USGS' 'Berkeley' ...
        'Caltech' 'LLNL' 'EVLOC' 'JSOP' 'User' 'Unknown' ...
        ...% ievtyp
        'Quarry/Mine Blast, Confirmed by Quarry' ... 
        'Quarry/Mine Blast with Shot Information, Ripple Fired' ... 
        'Quarry/Mine Blast with Observed Shot Information, Ripple Fired' ...
        'Quarry/Mine Blast, Single Shot' ...
        'Quarry or Mining Induced Events, Tremors and Rockbursts' ...
        'Earthquake' 'Earthquake, Swarm or Aftershock Sequence' ...
        'Earthquake, Felt' 'Marine Explosion' 'Other Explosion' ...
        'Nuclear Explosion' 'Nuclear Cavity Collapse' ...
        'Other Source, Known Origin' 'Local Event, Unknown Origin' ...
        'Regional Event, Unknown Origin' ...
        'Teleseismic Event, Unknown Origin' ...	
        'Undetermined or Conflicting Information' ...
        'Damaging Earthquake' 'Probable Earthquake' 'Probable Explosion' ...
        'Mine Collapse' 'Probable Mine Blast' 'Geyser' 'Light' ...
        'Meteroic Event' 'Odors'};
    
    header.lgc.startbyte=420;
    header.lgc.store='int32';
    header.lgc.bytesize=4;
    header.lgc.numfields=5;
    header.lgc.size=5;
    header.lgc.minpos=106;
    header.lgc.maxpos=110;
    header.lgc.pos=struct('leven',106,'lpspol',107,'lovrok',108,...
        'lcalda',109,'unused27',110);
    
    header.char.startbyte=440;
    header.char.store='char';
    header.char.bytesize=1;
    header.char.numfields=23;
    header.char.size=192;
    header.char.minpos=111;
    header.char.maxpos=302;
    header.char.pos=struct('kstnm',[111,118],'kevnm',[119,134],...
        'khole',[135,142],'ko',[143,150],'ka',[151,158],'kt0',[159,166],...
        'kt1',[167,174],'kt2',[175,182],'kt3',[183,190],'kt4',[191,198],...
        'kt5',[199,206],'kt6',[207,214],'kt7',[215,222],'kt8',[223,230],...
        'kt9',[231,238],'kf',[239,246],'kuser0',[247,254],...
        'kuser1',[255,262],'kuser2',[263,270],'kcmpnm',[271,278],...
        'knetwk',[279,286],'kdatrd',[287,294],'kinst',[295,302]);
    
    
    % SAClab version 101 header mod (npts/nspts become double ints)
    % NOTE - SAClab stores header values in 
    if(any(version==[101 102 201 202]))
        header.version=101;
        
        % change internal SAClab header storage type
        header.store='double';
        
        % split v6 'single' int group into 3 (npts/nspts go double int)
        %header.int(1).startbyte=280;
        %header.int(1).store='int32';
        %header.int(1).bytesize=4;
        header.int(1).numfields=9;
        header.int(1).size=9;
        header.int(1).minpos=71;
        header.int(1).maxpos=79;
        header.int(1).pos=struct('nzyear',71,'nzjday',72,'nzhour',73,...
            'nzmin',74,'nzsec',75,'nzmsec',76,'nvhdr',77,'norid',78,...
            'nevid',79);
        
        header.int(2).startbyte=316;
        header.int(2).store='int64';
        header.int(2).bytesize=8;
        header.int(2).numfields=2;
        header.int(2).size=2;
        header.int(2).minpos=80;
        header.int(2).maxpos=81;
        header.int(2).pos=struct('npts',80,'nspts',81);
        
        header.int(3).startbyte=332;
        header.int(3).store='int32';
        header.int(3).bytesize=4;
        header.int(3).numfields=4;
        header.int(3).size=4;
        header.int(3).minpos=82;
        header.int(3).maxpos=85;
        header.int(3).pos=struct('nwfid',82,'nxsize',83,'nysize',84,...
            'unused15',85);
        
        % push enum/logic in and char/data out
        header.enum.startbyte=348;
        header.lgc.startbyte=428;
        header.char.startbyte=448;
        header.data.startbyte=640;
    end
    
    
    % SAClab version 102 header mod (101 + multi-component support)
    if(any(version==[102 202]))
        header.version=102;
        
        % replace unused15 with ncmp (number of dependent components)
        header.int(3).pos=rmfield(header.int(3).pos,'unused15');
        header.int(3).pos.ncmp=85;
        
        % add new iftype enum
        header.enum.maxval=98;
        header.enum.id{99}='incmp';
        header.enum.val.incmp=98;
        header.enum.desc{99}='Multi-Component Time Series File';
    end
    
    
    % SAClab version 200 header mod (double reals, double data)
    if(any(version==[200 201 202]))
        header.version=200;
        
        % change internal SAClab header storage type
        header.store='double';
        
        % split v6 'single' real group into 2 'double' real groups
        %header.real(1).startbyte=0;
        header.real(1).store='double';
        header.real(1).bytesize=8;
        header.real(1).numfields=35;
        header.real(1).size=35;
        %header.real(1).minpos=1;
        header.real(1).maxpos=35;
        header.real(1).pos=struct('delta',1,'depmin',2,'depmax',3,...
            'scale',4,'odelta',5,'b',6,'e',7,'o',8,'a',9,'fmt',10,'t0',11,...
            't1',12,'t2',13,'t3',14,'t4',15,'t5',16,'t6',17,'t7',18,...
            't8',19,'t9',20,'f',21,'resp0',22,'resp1',23,'resp2',24,...
            'resp3',25,'resp4',26,'resp5',27,'resp6',28,'resp7',29,...
            'resp8',30,'resp9',31,'stla',32,'stlo',33,'stel',34,'stdp',35);
        
        header.real(2).startbyte=440;
        header.real(2).store='double';
        header.real(2).bytesize=8;
        header.real(2).numfields=35;
        header.real(2).size=35;
        header.real(2).minpos=36;
        header.real(2).maxpos=70;
        header.real(2).pos=struct('evla',36,'evlo',37,'evel',38,'evdp',39,...
            'mag',40,'user0',41,'user1',42,'user2',43,'user3',44,...
            'user4',45,'user5',46,'user6',47,'user7',48,'user8',49,...
            'user9',50,'dist',51,'az',52,'baz',53,'gcarc',54,'sb',55,...
            'sdelta',56,'depmen',57,'cmpaz',58,'cmpinc',59,'xminimum',60,...
            'xmaximum',61,'yminimum',62,'ymaximum',63,'unused6',64,...
            'unused7',65,'unused8',66,'unused9',67,'unused10',68,...
            'unused11',69,'unused12',70);
        
        % push char/data out 280 (keep char at end following SAC layout)
        header.char.startbyte=720;
        header.data.startbyte=912;
        
        % change data storage
        header.data.store='double';
        header.data.bytesize=8;
    end
    
    
    % SAClab version 201 header mod (101+200)
    if(any(version==[201 202]))
        header.version=201;
        
        % push out real(2)/char/data by 8 for 101 mod
        header.real(2).startbyte=448;
        header.char.startbyte=728;
        header.data.startbyte=920;
    end
    
    % SAClab version 202 header mod (101+102+200)
    if(any(version==[202]))
        header.version=202;
    end
end

% export structure
varargout{1}=header;

end
