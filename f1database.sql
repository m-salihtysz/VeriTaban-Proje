PGDMP  ;                    |         
   f1database    17.2    17.2 ]    I           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            J           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            K           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            L           1262    16389 
   f1database    DATABASE     �   CREATE DATABASE f1database WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE f1database;
                     postgres    false            �            1255    16391 8   araba_ekle(integer, integer, character varying, boolean) 	   PROCEDURE     �  CREATE PROCEDURE public.araba_ekle(IN pk integer, IN hp integer, IN colour character varying, IN wrck boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Araba tablosuna yeni bir kayıt ekleme
    INSERT INTO "CAR" ("CarID", "HorsePower", "Colour", "Wrecked")
    VALUES (pk, hp, colour, wrck);
    
    -- İşlem başarılı mesajı
    RAISE NOTICE 'Yeni araba kaydı eklendi. CarID: %', pk;
END;
$$;
 n   DROP PROCEDURE public.araba_ekle(IN pk integer, IN hp integer, IN colour character varying, IN wrck boolean);
       public               postgres    false            �            1255    16392    arabasilmefonksiyonu()    FUNCTION     �   CREATE FUNCTION public.arabasilmefonksiyonu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM "CAR_PARTS" WHERE NEW."CarID" = OLD."CarID";
    RAISE EXCEPTION 'PARCALAR SILINDI';
	RETURN OLD;
END;
$$;
 -   DROP FUNCTION public.arabasilmefonksiyonu();
       public               postgres    false            �            1255    16393 #   il_ekle(integer, character varying) 	   PROCEDURE     �   CREATE PROCEDURE public.il_ekle(IN p1 integer, IN p2 character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO "CITY" ("CityID", "CityName")
	VALUES (p1,p2);
END; 
$$;
 G   DROP PROCEDURE public.il_ekle(IN p1 integer, IN p2 character varying);
       public               postgres    false            �            1255    16394 '   lastik_ekle(integer, character varying) 	   PROCEDURE     4  CREATE PROCEDURE public.lastik_ekle(IN pk integer, IN ttype character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO "PREFERRED_TIRE" ("TireID", "TireType")
    VALUES (pk, tType);
    
    -- İşlem başarılı mesajı
    RAISE NOTICE 'Yeni lastik lkaydı eklendi. TireID: %', pk;
END;
$$;
 N   DROP PROCEDURE public.lastik_ekle(IN pk integer, IN ttype character varying);
       public               postgres    false            �            1255    16395    lastikturueklemetetikleyici()    FUNCTION        CREATE FUNCTION public.lastikturueklemetetikleyici() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM "PREFERRED_TIRE" WHERE "TireType" = NEW."TireType") THEN
        RAISE EXCEPTION 'Bu lastik türü zaten mevcut.';
    END IF;

    RETURN NEW;
END;
$$;
 4   DROP FUNCTION public.lastikturueklemetetikleyici();
       public               postgres    false            �            1255    16396 6   pist_ekle(integer, integer, integer, integer, integer) 	   PROCEDURE       CREATE PROCEDURE public.pist_ekle(IN p1 integer, IN p2 integer, IN p3 integer, IN p4 integer, IN p5 integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO "TRACK" ("TrackID","CityID","Distance","TurnsCount","TrackCapacity")
	VALUES (p1,p2,p3,p4,p5);
END; 
$$;
 l   DROP PROCEDURE public.pist_ekle(IN p1 integer, IN p2 integer, IN p3 integer, IN p4 integer, IN p5 integer);
       public               postgres    false            �            1255    16397 !   sponsormalzemeeklemetetikleyici()    FUNCTION     b  CREATE FUNCTION public.sponsormalzemeeklemetetikleyici() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Yeni bir malzeme eklenirken veya sponsoru değiştirilirken
    -- kontrol yapılır ve eğer sponsoru yoksa veya yanlış bir sponsor atanırsa işlem iptal edilir.
    IF NEW."SponsorID" IS NULL OR NOT EXISTS (SELECT 1 FROM "SPONSOR" WHERE "SponsorID" = NEW."SponsorID") THEN
        RAISE EXCEPTION 'Geçersiz sponsor, lütfen geçerli bir sponsor belirtin.';
    END IF;

    -- Eğer geçerli bir sponsor belirtilmişse işlem devam eder ve yeni malzeme eklenir.
    RETURN NEW;
END;
$$;
 8   DROP FUNCTION public.sponsormalzemeeklemetetikleyici();
       public               postgres    false            �            1255    16398    yarispistieklemetetikleyici()    FUNCTION     �  CREATE FUNCTION public.yarispistieklemetetikleyici() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM "TRACK" WHERE "TrackID" <> NEW."TrackID") THEN
        RAISE EXCEPTION 'Geçersiz pist IDsi, lütfen mevcut olmayan bir pist belirtin.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM "CITY" WHERE "CityID" = NEW."CityID") THEN
        RAISE EXCEPTION 'Bu pistin bulunduğu il mevcut değil.';
    END IF;

    RETURN NEW;
END;
$$;
 4   DROP FUNCTION public.yarispistieklemetetikleyici();
       public               postgres    false            �            1259    16399    CAR    TABLE     �   CREATE TABLE public."CAR" (
    "CarID" integer NOT NULL,
    "HorsePower" integer NOT NULL,
    "Colour" character varying(10),
    "Wrecked" boolean DEFAULT false
);
    DROP TABLE public."CAR";
       public         heap r       postgres    false            �            1259    16403 	   CAR_PARTS    TABLE     �   CREATE TABLE public."CAR_PARTS" (
    carid integer NOT NULL,
    partid integer NOT NULL,
    amount numeric DEFAULT 1 NOT NULL
);
    DROP TABLE public."CAR_PARTS";
       public         heap r       postgres    false            �            1259    16409    CITY    TABLE     d   CREATE TABLE public."CITY" (
    "CityID" integer NOT NULL,
    "CityName" character varying(20)
);
    DROP TABLE public."CITY";
       public         heap r       postgres    false            �            1259    16412    COUNTY    TABLE     �   CREATE TABLE public."COUNTY" (
    "CountyID" integer NOT NULL,
    "CityID" integer,
    "CountyName" character varying(20) NOT NULL
);
    DROP TABLE public."COUNTY";
       public         heap r       postgres    false            �            1259    16415    COUNTY_CountyID_seq    SEQUENCE     �   CREATE SEQUENCE public."COUNTY_CountyID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."COUNTY_CountyID_seq";
       public               postgres    false    220            M           0    0    COUNTY_CountyID_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public."COUNTY_CountyID_seq" OWNED BY public."COUNTY"."CountyID";
          public               postgres    false    221            �            1259    16416    PERSON    TABLE     �   CREATE TABLE public."PERSON" (
    "PersonID" integer NOT NULL,
    "Name" character varying(30),
    "DateOfBirth" date,
    "Gender" boolean NOT NULL
);
    DROP TABLE public."PERSON";
       public         heap r       postgres    false            �            1259    16419    DRIVER    TABLE     �   CREATE TABLE public."DRIVER" (
    "TeamID" integer NOT NULL,
    "CarID" integer NOT NULL,
    "DoorNumber" smallint,
    "Experience" smallint,
    "LicenseNumber" integer
)
INHERITS (public."PERSON");
    DROP TABLE public."DRIVER";
       public         heap r       postgres    false    222            �            1259    16422    PARTS    TABLE     �   CREATE TABLE public."PARTS" (
    "PartID" integer NOT NULL,
    "SponsorID" integer NOT NULL,
    "Name" character varying(30),
    "Stock" integer DEFAULT 0
);
    DROP TABLE public."PARTS";
       public         heap r       postgres    false            �            1259    16426    PREFERRED_TIRE    TABLE     n   CREATE TABLE public."PREFERRED_TIRE" (
    "TireID" integer NOT NULL,
    "TireType" character varying(15)
);
 $   DROP TABLE public."PREFERRED_TIRE";
       public         heap r       postgres    false            �            1259    16429    Person_PersonID_seq    SEQUENCE     �   CREATE SEQUENCE public."Person_PersonID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."Person_PersonID_seq";
       public               postgres    false    222            N           0    0    Person_PersonID_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public."Person_PersonID_seq" OWNED BY public."PERSON"."PersonID";
          public               postgres    false    226            �            1259    16430    RACE    TABLE     �   CREATE TABLE public."RACE" (
    "RaceID" integer NOT NULL,
    "TireID" integer NOT NULL,
    "TrackID" integer NOT NULL,
    "WeatherID" integer NOT NULL,
    "Date" date,
    "LapCount" integer
);
    DROP TABLE public."RACE";
       public         heap r       postgres    false            �            1259    16433    SPONSOR    TABLE     �   CREATE TABLE public."SPONSOR" (
    "SponsorID" integer NOT NULL,
    "TeamID" integer,
    "SponsorName" character varying(15),
    "SponsorType" character varying(20),
    "SponsorDescription" character varying(60)
);
    DROP TABLE public."SPONSOR";
       public         heap r       postgres    false            �            1259    16436    SPONSOR_MANAGER    TABLE     �   CREATE TABLE public."SPONSOR_MANAGER" (
    "SponsorID" integer NOT NULL,
    "Department" character varying(30),
    "ManagerSalary" integer,
    "ManagerContractType" character varying(30)
)
INHERITS (public."PERSON");
 %   DROP TABLE public."SPONSOR_MANAGER";
       public         heap r       postgres    false    222            �            1259    16439    TEAM    TABLE     �   CREATE TABLE public."TEAM" (
    "TeamID" integer NOT NULL,
    "TireID" integer NOT NULL,
    "TeamName" character varying(20) NOT NULL,
    "PitNumber" integer,
    "TotalWins" integer DEFAULT 0
);
    DROP TABLE public."TEAM";
       public         heap r       postgres    false            �            1259    16443    TEAM_MEMBER    TABLE     �   CREATE TABLE public."TEAM_MEMBER" (
    "TeamID" integer NOT NULL,
    "Position" integer,
    "TeamNumber" integer
)
INHERITS (public."PERSON");
 !   DROP TABLE public."TEAM_MEMBER";
       public         heap r       postgres    false    222            �            1259    16446 	   TEAM_RACE    TABLE     ^   CREATE TABLE public."TEAM_RACE" (
    teamid integer NOT NULL,
    raceid integer NOT NULL
);
    DROP TABLE public."TEAM_RACE";
       public         heap r       postgres    false            �            1259    16449    TRACK    TABLE     �   CREATE TABLE public."TRACK" (
    "TrackID" integer NOT NULL,
    "CityID" integer,
    "Distance" integer NOT NULL,
    "TurnsCount" integer NOT NULL,
    "TrackCapacity" integer NOT NULL
);
    DROP TABLE public."TRACK";
       public         heap r       postgres    false            �            1259    16452    TRACK_TrackID_seq    SEQUENCE     �   CREATE SEQUENCE public."TRACK_TrackID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public."TRACK_TrackID_seq";
       public               postgres    false    233            O           0    0    TRACK_TrackID_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public."TRACK_TrackID_seq" OWNED BY public."TRACK"."TrackID";
          public               postgres    false    234            �            1259    16453    WEATHER    TABLE     �   CREATE TABLE public."WEATHER" (
    "WeatherID" integer NOT NULL,
    "WeatherType" character varying(30),
    "CanRain" boolean
);
    DROP TABLE public."WEATHER";
       public         heap r       postgres    false            i           2604    16456    COUNTY CountyID    DEFAULT     x   ALTER TABLE ONLY public."COUNTY" ALTER COLUMN "CountyID" SET DEFAULT nextval('public."COUNTY_CountyID_seq"'::regclass);
 B   ALTER TABLE public."COUNTY" ALTER COLUMN "CountyID" DROP DEFAULT;
       public               postgres    false    221    220            k           2604    16457    DRIVER PersonID    DEFAULT     x   ALTER TABLE ONLY public."DRIVER" ALTER COLUMN "PersonID" SET DEFAULT nextval('public."Person_PersonID_seq"'::regclass);
 B   ALTER TABLE public."DRIVER" ALTER COLUMN "PersonID" DROP DEFAULT;
       public               postgres    false    226    223            j           2604    16458    PERSON PersonID    DEFAULT     x   ALTER TABLE ONLY public."PERSON" ALTER COLUMN "PersonID" SET DEFAULT nextval('public."Person_PersonID_seq"'::regclass);
 B   ALTER TABLE public."PERSON" ALTER COLUMN "PersonID" DROP DEFAULT;
       public               postgres    false    226    222            m           2604    16459    SPONSOR_MANAGER PersonID    DEFAULT     �   ALTER TABLE ONLY public."SPONSOR_MANAGER" ALTER COLUMN "PersonID" SET DEFAULT nextval('public."Person_PersonID_seq"'::regclass);
 K   ALTER TABLE public."SPONSOR_MANAGER" ALTER COLUMN "PersonID" DROP DEFAULT;
       public               postgres    false    229    226            o           2604    16460    TEAM_MEMBER PersonID    DEFAULT     }   ALTER TABLE ONLY public."TEAM_MEMBER" ALTER COLUMN "PersonID" SET DEFAULT nextval('public."Person_PersonID_seq"'::regclass);
 G   ALTER TABLE public."TEAM_MEMBER" ALTER COLUMN "PersonID" DROP DEFAULT;
       public               postgres    false    226    231            p           2604    16461    TRACK TrackID    DEFAULT     t   ALTER TABLE ONLY public."TRACK" ALTER COLUMN "TrackID" SET DEFAULT nextval('public."TRACK_TrackID_seq"'::regclass);
 @   ALTER TABLE public."TRACK" ALTER COLUMN "TrackID" DROP DEFAULT;
       public               postgres    false    234    233            4          0    16399    CAR 
   TABLE DATA           K   COPY public."CAR" ("CarID", "HorsePower", "Colour", "Wrecked") FROM stdin;
    public               postgres    false    217   �y       5          0    16403 	   CAR_PARTS 
   TABLE DATA           <   COPY public."CAR_PARTS" (carid, partid, amount) FROM stdin;
    public               postgres    false    218   �y       6          0    16409    CITY 
   TABLE DATA           6   COPY public."CITY" ("CityID", "CityName") FROM stdin;
    public               postgres    false    219   Cz       7          0    16412    COUNTY 
   TABLE DATA           F   COPY public."COUNTY" ("CountyID", "CityID", "CountyName") FROM stdin;
    public               postgres    false    220   �z       :          0    16419    DRIVER 
   TABLE DATA           �   COPY public."DRIVER" ("PersonID", "Name", "DateOfBirth", "Gender", "TeamID", "CarID", "DoorNumber", "Experience", "LicenseNumber") FROM stdin;
    public               postgres    false    223   �{       ;          0    16422    PARTS 
   TABLE DATA           I   COPY public."PARTS" ("PartID", "SponsorID", "Name", "Stock") FROM stdin;
    public               postgres    false    224   |       9          0    16416    PERSON 
   TABLE DATA           O   COPY public."PERSON" ("PersonID", "Name", "DateOfBirth", "Gender") FROM stdin;
    public               postgres    false    222   i|       <          0    16426    PREFERRED_TIRE 
   TABLE DATA           @   COPY public."PREFERRED_TIRE" ("TireID", "TireType") FROM stdin;
    public               postgres    false    225   �|       >          0    16430    RACE 
   TABLE DATA           `   COPY public."RACE" ("RaceID", "TireID", "TrackID", "WeatherID", "Date", "LapCount") FROM stdin;
    public               postgres    false    227   �|       ?          0    16433    SPONSOR 
   TABLE DATA           n   COPY public."SPONSOR" ("SponsorID", "TeamID", "SponsorName", "SponsorType", "SponsorDescription") FROM stdin;
    public               postgres    false    228   B}       @          0    16436    SPONSOR_MANAGER 
   TABLE DATA           �   COPY public."SPONSOR_MANAGER" ("PersonID", "Name", "DateOfBirth", "Gender", "SponsorID", "Department", "ManagerSalary", "ManagerContractType") FROM stdin;
    public               postgres    false    229   ~       A          0    16439    TEAM 
   TABLE DATA           Z   COPY public."TEAM" ("TeamID", "TireID", "TeamName", "PitNumber", "TotalWins") FROM stdin;
    public               postgres    false    230   �~       B          0    16443    TEAM_MEMBER 
   TABLE DATA           x   COPY public."TEAM_MEMBER" ("PersonID", "Name", "DateOfBirth", "Gender", "TeamID", "Position", "TeamNumber") FROM stdin;
    public               postgres    false    231   \       C          0    16446 	   TEAM_RACE 
   TABLE DATA           5   COPY public."TEAM_RACE" (teamid, raceid) FROM stdin;
    public               postgres    false    232   �       D          0    16449    TRACK 
   TABLE DATA           a   COPY public."TRACK" ("TrackID", "CityID", "Distance", "TurnsCount", "TrackCapacity") FROM stdin;
    public               postgres    false    233   �       F          0    16453    WEATHER 
   TABLE DATA           J   COPY public."WEATHER" ("WeatherID", "WeatherType", "CanRain") FROM stdin;
    public               postgres    false    235   �       P           0    0    COUNTY_CountyID_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."COUNTY_CountyID_seq"', 1, false);
          public               postgres    false    221            Q           0    0    Person_PersonID_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."Person_PersonID_seq"', 1, false);
          public               postgres    false    226            R           0    0    TRACK_TrackID_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."TRACK_TrackID_seq"', 1, false);
          public               postgres    false    234            r           2606    16463    CAR CAR_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public."CAR"
    ADD CONSTRAINT "CAR_pkey" PRIMARY KEY ("CarID");
 :   ALTER TABLE ONLY public."CAR" DROP CONSTRAINT "CAR_pkey";
       public                 postgres    false    217            v           2606    16465    CITY CITY_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public."CITY"
    ADD CONSTRAINT "CITY_pkey" PRIMARY KEY ("CityID");
 <   ALTER TABLE ONLY public."CITY" DROP CONSTRAINT "CITY_pkey";
       public                 postgres    false    219            x           2606    16467    COUNTY CountyPK 
   CONSTRAINT     Y   ALTER TABLE ONLY public."COUNTY"
    ADD CONSTRAINT "CountyPK" PRIMARY KEY ("CountyID");
 =   ALTER TABLE ONLY public."COUNTY" DROP CONSTRAINT "CountyPK";
       public                 postgres    false    220            |           2606    16469    DRIVER DRIVER_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public."DRIVER"
    ADD CONSTRAINT "DRIVER_pkey" PRIMARY KEY ("PersonID");
 @   ALTER TABLE ONLY public."DRIVER" DROP CONSTRAINT "DRIVER_pkey";
       public                 postgres    false    223            ~           2606    16471    PARTS PARTS_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public."PARTS"
    ADD CONSTRAINT "PARTS_pkey" PRIMARY KEY ("PartID");
 >   ALTER TABLE ONLY public."PARTS" DROP CONSTRAINT "PARTS_pkey";
       public                 postgres    false    224            �           2606    16473 "   PREFERRED_TIRE PREFERRED_TIRE_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."PREFERRED_TIRE"
    ADD CONSTRAINT "PREFERRED_TIRE_pkey" PRIMARY KEY ("TireID");
 P   ALTER TABLE ONLY public."PREFERRED_TIRE" DROP CONSTRAINT "PREFERRED_TIRE_pkey";
       public                 postgres    false    225            z           2606    16475    PERSON PersonPK 
   CONSTRAINT     Y   ALTER TABLE ONLY public."PERSON"
    ADD CONSTRAINT "PersonPK" PRIMARY KEY ("PersonID");
 =   ALTER TABLE ONLY public."PERSON" DROP CONSTRAINT "PersonPK";
       public                 postgres    false    222            �           2606    16477    RACE RACE_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public."RACE"
    ADD CONSTRAINT "RACE_pkey" PRIMARY KEY ("RaceID");
 <   ALTER TABLE ONLY public."RACE" DROP CONSTRAINT "RACE_pkey";
       public                 postgres    false    227            �           2606    16479 $   SPONSOR_MANAGER SPONSOR_MANAGER_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."SPONSOR_MANAGER"
    ADD CONSTRAINT "SPONSOR_MANAGER_pkey" PRIMARY KEY ("PersonID");
 R   ALTER TABLE ONLY public."SPONSOR_MANAGER" DROP CONSTRAINT "SPONSOR_MANAGER_pkey";
       public                 postgres    false    229            �           2606    16481    SPONSOR SPONSOR_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public."SPONSOR"
    ADD CONSTRAINT "SPONSOR_pkey" PRIMARY KEY ("SponsorID");
 B   ALTER TABLE ONLY public."SPONSOR" DROP CONSTRAINT "SPONSOR_pkey";
       public                 postgres    false    228            �           2606    16483    TEAM_MEMBER TEAM_MEMBER_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public."TEAM_MEMBER"
    ADD CONSTRAINT "TEAM_MEMBER_pkey" PRIMARY KEY ("PersonID");
 J   ALTER TABLE ONLY public."TEAM_MEMBER" DROP CONSTRAINT "TEAM_MEMBER_pkey";
       public                 postgres    false    231            �           2606    16485    TEAM TEAM_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public."TEAM"
    ADD CONSTRAINT "TEAM_pkey" PRIMARY KEY ("TeamID");
 <   ALTER TABLE ONLY public."TEAM" DROP CONSTRAINT "TEAM_pkey";
       public                 postgres    false    230            �           2606    16487    TRACK TrackPK 
   CONSTRAINT     V   ALTER TABLE ONLY public."TRACK"
    ADD CONSTRAINT "TrackPK" PRIMARY KEY ("TrackID");
 ;   ALTER TABLE ONLY public."TRACK" DROP CONSTRAINT "TrackPK";
       public                 postgres    false    233            �           2606    16489    WEATHER WEATHER_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public."WEATHER"
    ADD CONSTRAINT "WEATHER_pkey" PRIMARY KEY ("WeatherID");
 B   ALTER TABLE ONLY public."WEATHER" DROP CONSTRAINT "WEATHER_pkey";
       public                 postgres    false    235            t           2606    16491    CAR_PARTS carpartsfk 
   CONSTRAINT     _   ALTER TABLE ONLY public."CAR_PARTS"
    ADD CONSTRAINT carpartsfk PRIMARY KEY (carid, partid);
 @   ALTER TABLE ONLY public."CAR_PARTS" DROP CONSTRAINT carpartsfk;
       public                 postgres    false    218    218            �           2606    16493    TEAM_RACE teamracefk 
   CONSTRAINT     `   ALTER TABLE ONLY public."TEAM_RACE"
    ADD CONSTRAINT teamracefk PRIMARY KEY (teamid, raceid);
 @   ALTER TABLE ONLY public."TEAM_RACE" DROP CONSTRAINT teamracefk;
       public                 postgres    false    232    232            �           2620    16494    CAR arabasilmetetikleyici    TRIGGER        CREATE TRIGGER arabasilmetetikleyici AFTER DELETE ON public."CAR" FOR EACH ROW EXECUTE FUNCTION public.arabasilmefonksiyonu();
 4   DROP TRIGGER arabasilmetetikleyici ON public."CAR";
       public               postgres    false    217    237            �           2620    16495 1   PREFERRED_TIRE lastikturueklemekontroltetikleyici    TRIGGER     �   CREATE TRIGGER lastikturueklemekontroltetikleyici BEFORE INSERT ON public."PREFERRED_TIRE" FOR EACH ROW EXECUTE FUNCTION public.lastikturueklemetetikleyici();
 L   DROP TRIGGER lastikturueklemekontroltetikleyici ON public."PREFERRED_TIRE";
       public               postgres    false    225    240            �           2620    16496    PARTS malzemeeklemetetikleyici    TRIGGER     �   CREATE TRIGGER malzemeeklemetetikleyici BEFORE INSERT OR UPDATE ON public."PARTS" FOR EACH ROW EXECUTE FUNCTION public.sponsormalzemeeklemetetikleyici();
 9   DROP TRIGGER malzemeeklemetetikleyici ON public."PARTS";
       public               postgres    false    224    242            �           2620    16497 (   TRACK yarispistieklemekontroltetikleyici    TRIGGER     �   CREATE TRIGGER yarispistieklemekontroltetikleyici BEFORE INSERT ON public."TRACK" FOR EACH ROW EXECUTE FUNCTION public.yarispistieklemetetikleyici();
 C   DROP TRIGGER yarispistieklemekontroltetikleyici ON public."TRACK";
       public               postgres    false    243    233            �           2606    16498    DRIVER CarID    FK CONSTRAINT     ~   ALTER TABLE ONLY public."DRIVER"
    ADD CONSTRAINT "CarID" FOREIGN KEY ("CarID") REFERENCES public."CAR"("CarID") NOT VALID;
 :   ALTER TABLE ONLY public."DRIVER" DROP CONSTRAINT "CarID";
       public               postgres    false    217    4722    223            �           2606    16503    COUNTY IlFK    FK CONSTRAINT     �   ALTER TABLE ONLY public."COUNTY"
    ADD CONSTRAINT "IlFK" FOREIGN KEY ("CityID") REFERENCES public."CITY"("CityID") ON DELETE CASCADE;
 9   ALTER TABLE ONLY public."COUNTY" DROP CONSTRAINT "IlFK";
       public               postgres    false    219    4726    220            �           2606    16508 
   TRACK IlFK    FK CONSTRAINT     �   ALTER TABLE ONLY public."TRACK"
    ADD CONSTRAINT "IlFK" FOREIGN KEY ("CityID") REFERENCES public."CITY"("CityID") ON DELETE CASCADE;
 8   ALTER TABLE ONLY public."TRACK" DROP CONSTRAINT "IlFK";
       public               postgres    false    4726    233    219            �           2606    16513    SPONSOR_MANAGER SponsorFK    FK CONSTRAINT     �   ALTER TABLE ONLY public."SPONSOR_MANAGER"
    ADD CONSTRAINT "SponsorFK" FOREIGN KEY ("SponsorID") REFERENCES public."SPONSOR"("SponsorID") ON UPDATE RESTRICT ON DELETE RESTRICT NOT VALID;
 G   ALTER TABLE ONLY public."SPONSOR_MANAGER" DROP CONSTRAINT "SponsorFK";
       public               postgres    false    4740    228    229            �           2606    16518    PARTS SponsorFK    FK CONSTRAINT     �   ALTER TABLE ONLY public."PARTS"
    ADD CONSTRAINT "SponsorFK" FOREIGN KEY ("SponsorID") REFERENCES public."SPONSOR"("SponsorID") ON UPDATE RESTRICT ON DELETE RESTRICT NOT VALID;
 =   ALTER TABLE ONLY public."PARTS" DROP CONSTRAINT "SponsorFK";
       public               postgres    false    4740    224    228            �           2606    16523    TEAM_MEMBER TeamFK    FK CONSTRAINT     �   ALTER TABLE ONLY public."TEAM_MEMBER"
    ADD CONSTRAINT "TeamFK" FOREIGN KEY ("TeamID") REFERENCES public."TEAM"("TeamID") NOT VALID;
 @   ALTER TABLE ONLY public."TEAM_MEMBER" DROP CONSTRAINT "TeamFK";
       public               postgres    false    4744    230    231            �           2606    16528    DRIVER TeamFK    FK CONSTRAINT     �   ALTER TABLE ONLY public."DRIVER"
    ADD CONSTRAINT "TeamFK" FOREIGN KEY ("TeamID") REFERENCES public."TEAM"("TeamID") NOT VALID;
 ;   ALTER TABLE ONLY public."DRIVER" DROP CONSTRAINT "TeamFK";
       public               postgres    false    4744    230    223            �           2606    16533    RACE TireFK    FK CONSTRAINT     �   ALTER TABLE ONLY public."RACE"
    ADD CONSTRAINT "TireFK" FOREIGN KEY ("TireID") REFERENCES public."PREFERRED_TIRE"("TireID");
 9   ALTER TABLE ONLY public."RACE" DROP CONSTRAINT "TireFK";
       public               postgres    false    225    227    4736            �           2606    16538    RACE TrackFK    FK CONSTRAINT     z   ALTER TABLE ONLY public."RACE"
    ADD CONSTRAINT "TrackFK" FOREIGN KEY ("TrackID") REFERENCES public."TRACK"("TrackID");
 :   ALTER TABLE ONLY public."RACE" DROP CONSTRAINT "TrackFK";
       public               postgres    false    233    227    4750            �           2606    16543    RACE WeatherFK    FK CONSTRAINT     �   ALTER TABLE ONLY public."RACE"
    ADD CONSTRAINT "WeatherFK" FOREIGN KEY ("WeatherID") REFERENCES public."WEATHER"("WeatherID");
 <   ALTER TABLE ONLY public."RACE" DROP CONSTRAINT "WeatherFK";
       public               postgres    false    227    235    4752            �           2606    16548    CAR_PARTS car_parts_carid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."CAR_PARTS"
    ADD CONSTRAINT car_parts_carid_fkey FOREIGN KEY (carid) REFERENCES public."CAR"("CarID") ON UPDATE CASCADE ON DELETE CASCADE;
 J   ALTER TABLE ONLY public."CAR_PARTS" DROP CONSTRAINT car_parts_carid_fkey;
       public               postgres    false    217    4722    218            �           2606    16553    CAR_PARTS car_parts_partid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."CAR_PARTS"
    ADD CONSTRAINT car_parts_partid_fkey FOREIGN KEY (partid) REFERENCES public."PARTS"("PartID") ON UPDATE CASCADE;
 K   ALTER TABLE ONLY public."CAR_PARTS" DROP CONSTRAINT car_parts_partid_fkey;
       public               postgres    false    4734    218    224            �           2606    16558    TEAM_RACE team_race_raceid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."TEAM_RACE"
    ADD CONSTRAINT team_race_raceid_fkey FOREIGN KEY (raceid) REFERENCES public."RACE"("RaceID") ON UPDATE CASCADE;
 K   ALTER TABLE ONLY public."TEAM_RACE" DROP CONSTRAINT team_race_raceid_fkey;
       public               postgres    false    227    232    4738            �           2606    16563    TEAM_RACE team_race_teamid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."TEAM_RACE"
    ADD CONSTRAINT team_race_teamid_fkey FOREIGN KEY (teamid) REFERENCES public."TEAM"("TeamID") ON UPDATE CASCADE ON DELETE CASCADE;
 K   ALTER TABLE ONLY public."TEAM_RACE" DROP CONSTRAINT team_race_teamid_fkey;
       public               postgres    false    230    232    4744            4   P   x�3�453�t/JM��,�2�8#Ssr��9Ӹ��\cN��ļ�T ��5�t�IL���9�ML9c�@F`S��21z\\\ �c      5   6   x���	 0�:L!��K����s�qBAl'l�Y9ՙ���L�����]$���      6   �   x��;�0E�z�b� �MC�� ��f�XNf$���b,�W:��#{oFE���jj]��<G���6�0�tas�*�P�lΣ��N�-4�!��K:�� |�(���dS6�s��UM��E�>M�. �A%*L      7   �   x�=�=�@��Ƹ�Sb4ZXIk��O�@v̓h�e<�=z/i���L� ��7=jy�(B�B*=P�-�ǔ F���%���eH�g/W��Q��F�]�3��Ȱ���7�Ύ�Z��˕xnI�q��!��h�aRP���i[3O�<Q��Bz��"�/U�4e      :   u   x��1�0D�z�.�<��7�%J���q��"���X������򘷶��TX�AaH��d�,	�c=���1ՙ#d����ƶ�u������Z�%(�f�🞋U�"�ɹ_      ;   R   x��1
�0D���a�$F���J�����W��L$��t�p��Q�LR�g.����yy"k�3A����^�J-S��A[#� S      9      x������ � �      <   >   x�3�J�̫�2��H,J�2���L��2��O+�2�.)JM-�4�N��KB�b���� :�      >   ^   x�=��1���..d9I�]������A����I#2C�������ژ�H�Yn�����m�������͍Ec���pfެ�^���/����      ?   �   x�-���0��ӧ�	�"������G/KYuCmI[bx{=�f����q/ps]��sD횡���g��$��To��vX�<�{_;d�"邨-2Ty�Ə1Lm��B�w}(��wNh��l� �:y�<�Z������'g:ڧX�Yqq���$_忮�B�(�{�X���\I�}��#��'tO�R_- J�      @   �   x�U��j�0E�W����m��dQ($ŐB7�w�E9�j���-�͙33���>)���;��B����w'&ޞ6@�_.:.U{�.�3{���mZ��dw��1d�e]�lp�]�J��D�"mLU�q�nM�
9�͕�p�3M�n������U�K��O���<T��)TF�-VE�`��|�T9U���'��X�漛h��2��;������[E      A   Y   x�˫�0P}�1$]y	�`0h��*H�-����?g��Rߒ1�`�!�K���LƩq�R����5��Y�,��mj�F�p�=�:"�t��      B   l   x�˱
�PF��ϻD��x������!�B-E�����_Ő���e	�0��˖�\a"�R���^Q�.sz�~��Xz��8Wj�=�y�RX���	�{��� i`      C   4   x��� A�b(�$�f��� ��(�[E��K��[��p�.����g��M      D   S   x����P��bV�/I/鿎5��f��p��m�Hգ�	������1�/�:��\oA�-����,Z@mR�gu��?3�2�      F   (   x�3�J�̫�,�2�t��/M19�K�i\1z\\\ ��	q     