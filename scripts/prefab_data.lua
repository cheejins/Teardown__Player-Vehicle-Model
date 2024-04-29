--- Creates a prefab object.
function prefab_create(folder, file, title, tags)
    return {
        path    = RootPath .. folder .. file,
        folder  = folder,
        file    = file,
        title   = title,
        tags    = tags,
    }
end

-- List of all prefab objects.
function init_prefab_objects()

    PrefabObjects = {}


    PrefabObjects[Folders.Snakey] = {
        prefab_create(Folders.Snakey,    "106.xml",                     "106",                    {Tags.creature}),
        prefab_create(Folders.Snakey,    "49.xml",                      "49",                     {Tags.creature}),
        prefab_create(Folders.Snakey,    "662.xml",                     "662",                    {Tags.business}),
        prefab_create(Folders.Snakey,    "96.xml",                      "96",                     {Tags.creature}),
        prefab_create(Folders.Snakey,    "Alien.xml",                   "Alien",                  {Tags.creature}),
        prefab_create(Folders.Snakey,    "Bandi.xml",                   "Bandi",                  {Tags.youtuber}),
        prefab_create(Folders.Snakey,    "BusinessMan.xml",             "BusinessMan",            {Tags.business}),
        prefab_create(Folders.Snakey,    "Cartel.xml",                  "Cartel",                 {Tags.militia}),
        prefab_create(Folders.Snakey,    "CI.xml",                      "CI",                     {Tags.military}),
        prefab_create(Folders.Snakey,    "Clown.xml",                   "Clown",                  {Tags.civilian}),
        prefab_create(Folders.Snakey,    "ConstructionWorker.xml",      "ConstructionWorker",     {Tags.civilian}),
        prefab_create(Folders.Snakey,    "DClass1.xml",                 "DClass1",                {Tags.civilian}),
        prefab_create(Folders.Snakey,    "DClass2.xml",                 "DClass2",                {Tags.civilian}),
        prefab_create(Folders.Snakey,    "DClass3.xml",                 "DClass3",                {Tags.civilian}),
        prefab_create(Folders.Snakey,    "DClass4.xml",                 "DClass4",                {Tags.civilian}),
        prefab_create(Folders.Snakey,    "DClass5.xml",                 "DClass5",                {Tags.civilian}),
        prefab_create(Folders.Snakey,    "DClass6.xml",                 "DClass6",                {Tags.civilian}),
        prefab_create(Folders.Snakey,    "Denis.xml",                   "Denis",                  {Tags.teardown}),
        prefab_create(Folders.Snakey,    "Drae.xml",                    "Drae" ,                  {Tags.youtuber}),
        prefab_create(Folders.Snakey,    "DrunkBusinessMan.xml",        "DrunkBusinessMan" ,      {Tags.business}),
        prefab_create(Folders.Snakey,    "DrunkBusinessManDRIVER.xml",  "DrunkBusinessManDRIVER", {Tags.business}),
        prefab_create(Folders.Snakey,    "Emil.xml",                    "Emil" ,                  {Tags.teardown}),
        prefab_create(Folders.Snakey,    "FGuard.xml",                  "FGuard",                 {Tags.police}),
        prefab_create(Folders.Snakey,    "FireFighter.xml",             "FireFighter",            {Tags.emt}),
        prefab_create(Folders.Snakey,    "Fynnpire.xml",                "Fynnpire" ,              {Tags.youtuber}),
        prefab_create(Folders.Snakey,    "GGPro.xml",                   "GGPro",                  {Tags.modder}),
        prefab_create(Folders.Snakey,    "GMan.xml",                    "GMan" ,                  {Tags.halfLife}),
        prefab_create(Folders.Snakey,    "Gus Fring.xml",               "Gus Fring",              {Tags.breakingBad}),
        prefab_create(Folders.Snakey,    "Hank Schrader.xml",           "Hank Schrader",          {Tags.breakingBad}),
        prefab_create(Folders.Snakey,    "Hazmat.xml",                  "Hazmat",                 {Tags.emt}),
        prefab_create(Folders.Snakey,    "Hector Salamanca.xml",        "Hector Salamanca" ,      {Tags.breakingBad}),
        prefab_create(Folders.Snakey,    "Heisenberg.xml",              "Heisenberg",             {Tags.breakingBad}),
        prefab_create(Folders.Snakey,    "Human.xml",                   "Human",                  {Tags.civilian}),
        prefab_create(Folders.Snakey,    "Human2.xml",                  "Human2",                 {Tags.civilian}),
        prefab_create(Folders.Snakey,    "IWillSunder.xml",             "IWillSunder",            {Tags.civilian}),
        prefab_create(Folders.Snakey,    "JacobMario.xml",              "JacobMario",             {Tags.modder}),
        prefab_create(Folders.Snakey,    "jesse Pinkman.xml",           "jesse Pinkman",          {Tags.breakingBad}),
        prefab_create(Folders.Snakey,    "Marina.xml",                  "Marina",                 {Tags.military}),
        prefab_create(Folders.Snakey,    "MI7.xml",                     "MI7",                    {Tags.military}),
        prefab_create(Folders.Snakey,    "Mike Ehrmantraut.xml",        "Mike Ehrmantraut",       {Tags.breakingBad}),
        prefab_create(Folders.Snakey,    "morvex.xml",                  "morvex",                 {Tags.modder}),
        prefab_create(Folders.Snakey,    "MTF.xml",                     "MTF",                    {Tags.military}),
        prefab_create(Folders.Snakey,    "OffensivePDF.xml",            "OffensivePDF",           {Tags.modder}),
        prefab_create(Folders.Snakey,    "ONSVRG.xml",                  "ONSVRG",                 {Tags.teardown}),
        prefab_create(Folders.Snakey,    "ParkingMeter.xml",            "ParkingMeter",           {Tags.modder}),
        prefab_create(Folders.Snakey,    "Pilot.xml",                   "Pilot",                  {Tags.pilot}),
        prefab_create(Folders.Snakey,    "PropGuy.xml",                 "PropGuy",                {Tags.modder}),
        prefab_create(Folders.Snakey,    "Riot.xml",                    "Riot",                   {Tags.police}),
        prefab_create(Folders.Snakey,    "RUSoldier1.xml",              "RUSoldier1",             {Tags.military}),
        prefab_create(Folders.Snakey,    "RUSoldier2.xml",              "RUSoldier2",             {Tags.military}),
        prefab_create(Folders.Snakey,    "RUSoldier3.xml",              "RUSoldier3",             {Tags.military}),
        prefab_create(Folders.Snakey,    "Saul Goodman.xml",            "Saul Goodman",           {Tags.breakingBad}),
        prefab_create(Folders.Snakey,    "Scientist.xml",               "Scientist",              {Tags.civilian}),
        prefab_create(Folders.Snakey,    "ScientistHAZARD.xml",         "ScientistHAZARD",        {Tags.emt}),
        prefab_create(Folders.Snakey,    "ScientistHEV.xml",            "ScientistHEV",           {Tags.emt}),
        prefab_create(Folders.Snakey,    "SnakeyWakey.xml",             "SnakeyWakey",            {Tags.modder}),
        prefab_create(Folders.Snakey,    "Soldier1.xml",                "Soldier1",               {Tags.military}),
        prefab_create(Folders.Snakey,    "Soldier2.xml",                "Soldier2",               {Tags.military}),
        prefab_create(Folders.Snakey,    "Soldier3.xml",                "Soldier3",               {Tags.military}),
        prefab_create(Folders.Snakey,    "Soldier4.xml",                "Soldier4",               {Tags.military}),
        prefab_create(Folders.Snakey,    "SoldierNVGoff.xml",           "SoldierNVGoff",          {Tags.military}),
        prefab_create(Folders.Snakey,    "SoldierNVGoff2.xml",          "SoldierNVGoff2",         {Tags.military}),
        prefab_create(Folders.Snakey,    "SoldierNVGon.xml",            "SoldierNVGon",           {Tags.military}),
        prefab_create(Folders.Snakey,    "SoymilkPapi.xml",             "SoymilkPapi",            {Tags.modder}),
        prefab_create(Folders.Snakey,    "StrainZex.xml",               "StrainZex",              {Tags.modder}),
        prefab_create(Folders.Snakey,    "SWAT.xml",                    "SWAT",                   {Tags.police}),
        prefab_create(Folders.Snakey,    "Therapist.xml",               "Therapist",              {Tags.civilian}),
        prefab_create(Folders.Snakey,    "UsernameTaken.xml",           "UsernameTaken",          {Tags.modder}),
        prefab_create(Folders.Snakey,    "Walter White Bald.xml",       "Walter White Bald",      {Tags.breakingBad}),
        prefab_create(Folders.Snakey,    "Walter White Cook.xml",       "Walter White Cook",      {Tags.breakingBad}),
        prefab_create(Folders.Snakey,    "Walter White Hazmat.xml",     "Walter White Hazmat",    {Tags.breakingBad}),
        prefab_create(Folders.Snakey,    "Walter White.xml",            "Walter White",           {Tags.breakingBad}),
        prefab_create(Folders.Snakey,    "Walter White2 Bald.xml",      "Walter White2 Bald",     {Tags.breakingBad}),
        prefab_create(Folders.Snakey,    "Walter White2.xml",           "Walter White2",          {Tags.breakingBad}),
        prefab_create(Folders.Snakey,    "WW2American.xml",             "WW2American",            {Tags.military}),
        prefab_create(Folders.Snakey,    "WW2American2.xml",            "WW2American2",           {Tags.military}),
        prefab_create(Folders.Snakey,    "WW2AmericanTanker.xml",       "WW2AmericanTanker",      {Tags.military}),
        prefab_create(Folders.Snakey,    "WW2German.xml",               "WW2German",              {Tags.military}),
        prefab_create(Folders.Snakey,    "WW2German2.xml",              "WW2German2",             {Tags.military}),

        -- ["Soldier5.xml"]               = "Soldier5.xml", --> Amogus
        -- ["Adrian Shephard.xml"]        = "Adrian Shephard.xml", --> Glitched
        -- ["Hector Salamanca.xml"]       = "Hector Salamanca.xml", --> Extra shapes

    }

    PrefabObjects[Folders.Agro] = {
        prefab_create(Folders.Agro, "ClassicEnemy1.xml",           "ClassicEnemy1",           {Tags.military}),
        prefab_create(Folders.Agro, "ClassicEnemy2.xml",           "ClassicEnemy2",           {Tags.military}),
        prefab_create(Folders.Agro, "ClassicEnemy3.xml",           "ClassicEnemy3",           {Tags.military}),
        prefab_create(Folders.Agro, "ClassicEnemy4.xml",           "ClassicEnemy4",           {Tags.military}),
        prefab_create(Folders.Agro, "ClassicFriend1.xml",          "ClassicFriend1",          {Tags.military}),
        prefab_create(Folders.Agro, "ClassicFriend2.xml",          "ClassicFriend2",          {Tags.military}),
        prefab_create(Folders.Agro, "ClassicFriend3.xml",          "ClassicFriend3",          {Tags.military}),
        prefab_create(Folders.Agro, "ClassicFriend4.xml",          "ClassicFriend4",          {Tags.military}),
        prefab_create(Folders.Agro, "ClassicFriendDefender.xml",   "ClassicFriendDefender",   {Tags.military}),
        prefab_create(Folders.Agro, "Friend2.xml",                 "Friend2",                 {Tags.military}),
        prefab_create(Folders.Agro, "Friend3.xml",                 "Friend3",                 {Tags.military}),
    }

    PrefabObjects[Folders.Avertnus] = {

        prefab_create(Folders.Avertnus,     "Avertnus.xml",     "Avertnus",     {Tags.militia}),
        prefab_create(Folders.Avertnus,     "Cayo1.xml",        "Cayo1",        {Tags.militia}),
        prefab_create(Folders.Avertnus,     "Cayo2.xml",        "Cayo2",        {Tags.militia}),
        prefab_create(Folders.Avertnus,     "Cayo3.xml",        "Cayo3",        {Tags.militia}),
        prefab_create(Folders.Avertnus,     "Cayo4.xml",        "Cayo4",        {Tags.militia}),
        prefab_create(Folders.Avertnus,     "Cayo5.xml",        "Cayo5",        {Tags.militia}),
        prefab_create(Folders.Avertnus,     "Cayo6.xml",        "Cayo6",        {Tags.militia}),
        prefab_create(Folders.Avertnus,     "Cayo7.xml",        "Cayo7",        {Tags.militia}),
        prefab_create(Folders.Avertnus,     "ElRubio.xml",      "ElRubio",      {Tags.militia}),


        prefab_create(Folders.Avertnus,     "HL2Cargo.xml",           "HL2Cargo",           {Tags.halfLife}),
        prefab_create(Folders.Avertnus,     "OTA1.xml",        "OTA1",        {Tags.halfLife}),
        prefab_create(Folders.Avertnus,     "OTA2.xml",        "OTA2",        {Tags.halfLife}),
        prefab_create(Folders.Avertnus,     "OTA3.xml",        "OTA3",        {Tags.halfLife}),
        prefab_create(Folders.Avertnus,     "Rebel1.xml",      "Rebel1",      {Tags.halfLife}),
        prefab_create(Folders.Avertnus,     "Rebel2.xml",      "Rebel2",      {Tags.halfLife}),
        prefab_create(Folders.Avertnus,     "Rebel3.xml",      "Rebel3",      {Tags.halfLife}),
        prefab_create(Folders.Avertnus,     "Rebel4.xml",      "Rebel4",      {Tags.halfLife}),


        prefab_create(Folders.Avertnus,     "Insurgent1.xml",           "Insurgent1",           {Tags.militia}),
        prefab_create(Folders.Avertnus,     "Insurgent2.xml",           "Insurgent2",           {Tags.militia}),
        prefab_create(Folders.Avertnus,     "Insurgent3.xml",           "Insurgent3",           {Tags.militia}),
        prefab_create(Folders.Avertnus,     "Insurgent4.xml",           "Insurgent4",           {Tags.militia}),
        prefab_create(Folders.Avertnus,     "Insurgent5.xml",           "Insurgent5",           {Tags.militia}),
        prefab_create(Folders.Avertnus,     "Insurgent6.xml",           "Insurgent6",           {Tags.militia}),
        prefab_create(Folders.Avertnus,     "Insurgent7.xml",           "Insurgent7",           {Tags.militia}),


        prefab_create(Folders.Avertnus,     "US1.xml",              "US1",           {Tags.military}),
        prefab_create(Folders.Avertnus,     "US2.xml",              "US2",           {Tags.military}),
        prefab_create(Folders.Avertnus,     "US3.xml",              "US3",           {Tags.military}),
        prefab_create(Folders.Avertnus,     "US4.xml",              "US4",           {Tags.military}),
        prefab_create(Folders.Avertnus,     "US5.xml",              "US5",           {Tags.military}),
        prefab_create(Folders.Avertnus,     "USNam1.xml",           "USNam1",        {Tags.military}),
        prefab_create(Folders.Avertnus,     "USNam2.xml",           "USNam2",        {Tags.military}),
        prefab_create(Folders.Avertnus,     "USNam3.xml",           "USNam3",        {Tags.military}),
        prefab_create(Folders.Avertnus,     "USNamEngie.xml",       "USNamEngie",    {Tags.military}),
        prefab_create(Folders.Avertnus,     "USNamOfficer1.xml",    "USNamOfficer1", {Tags.military}),
        prefab_create(Folders.Avertnus,     "USNamOfficer2.xml",    "USNamOfficer2", {Tags.military}),

    }

    PrefabObjects[Folders.Darren] = {
        prefab_create(Folders.Darren,   "AKsoldier1.xml",     "AKsoldier1",     {Tags.military}),
        prefab_create(Folders.Darren,   "AKsoldier2.xml",     "AKsoldier2",     {Tags.military}),
        prefab_create(Folders.Darren,   "AKsoldier3.xml",     "AKsoldier3",     {Tags.military}),
        prefab_create(Folders.Darren,   "AKsoldier4.xml",     "AKsoldier4",     {Tags.military}),
        prefab_create(Folders.Darren,   "AKsoldier5.xml",     "AKsoldier5",     {Tags.military}),
        prefab_create(Folders.Darren,   "Amsoldier1.xml",     "Amsoldier1",     {Tags.military}),
        prefab_create(Folders.Darren,   "Gsoldier1.xml",      "Gsoldier1",      {Tags.military}),
        prefab_create(Folders.Darren,   "Gsoldier10.xml",     "Gsoldier10",     {Tags.military}),
        prefab_create(Folders.Darren,   "Gsoldier11.xml",     "Gsoldier11",     {Tags.military}),
        prefab_create(Folders.Darren,   "Gsoldier12.xml",     "Gsoldier12",     {Tags.military}),
        prefab_create(Folders.Darren,   "Gsoldier13.xml",     "Gsoldier13",     {Tags.military}),
        prefab_create(Folders.Darren,   "Gsoldier2.xml",      "Gsoldier2",      {Tags.military}),
        prefab_create(Folders.Darren,   "Gsoldier3.xml",      "Gsoldier3",      {Tags.military}),
        prefab_create(Folders.Darren,   "Gsoldier4.xml",      "Gsoldier4",      {Tags.military}),
        prefab_create(Folders.Darren,   "Gsoldier5.xml",      "Gsoldier5",      {Tags.military}),
        prefab_create(Folders.Darren,   "Gsoldier6.xml",      "Gsoldier6",      {Tags.military}),
        prefab_create(Folders.Darren,   "Gsoldier7.xml",      "Gsoldier7",      {Tags.military}),
        prefab_create(Folders.Darren,   "Gsoldier8.xml",      "Gsoldier8",      {Tags.military}),
        prefab_create(Folders.Darren,   "Gsoldier9.xml",      "Gsoldier9",      {Tags.military}),
        prefab_create(Folders.Darren,   "Isoldier1.xml",      "Isoldier1",      {Tags.military}),
        prefab_create(Folders.Darren,   "Isoldier3.xml",      "Isoldier3",      {Tags.military}),
        prefab_create(Folders.Darren,   "Isoldier6.xml",      "Isoldier6",      {Tags.military}),
        prefab_create(Folders.Darren,   "Isoldier7.xml",      "Isoldier7",      {Tags.military}),
        prefab_create(Folders.Darren,   "KMsoldier1.xml",     "KMsoldier1",     {Tags.military}),
        prefab_create(Folders.Darren,   "KMsoldier2.xml",     "KMsoldier2",     {Tags.military}),
        prefab_create(Folders.Darren,   "KMsoldier3.xml",     "KMsoldier3",     {Tags.military}),
        prefab_create(Folders.Darren,   "KMsoldier4.xml",     "KMsoldier4",     {Tags.military}),
        prefab_create(Folders.Darren,   "LWsoldier1.xml",     "LWsoldier1",     {Tags.military}),
        prefab_create(Folders.Darren,   "SOsoldier1.xml",     "SOsoldier1",     {Tags.military}),
        prefab_create(Folders.Darren,   "SOsoldier2.xml",     "SOsoldier2",     {Tags.military}),
        prefab_create(Folders.Darren,   "SSsoldier1.xml",     "SSsoldier1",     {Tags.military}),
        prefab_create(Folders.Darren,   "SSsoldier2.xml",     "SSsoldier2",     {Tags.military})
    }

    PrefabObjects[Folders.EVGSTORE] = {
        prefab_create(Folders.EVGSTORE, "Blindnerd.xml",        "Blindnerd",      {Tags.civilian}),
        prefab_create(Folders.EVGSTORE, "Construction.xml",     "Construction",   {Tags.civilian}),
        prefab_create(Folders.EVGSTORE, "EVGSTORE.xml",         "EVGSTORE",       {Tags.modder}),
        prefab_create(Folders.EVGSTORE, "girl1.xml",            "girl1",          {Tags.civilian}),
        prefab_create(Folders.EVGSTORE, "hippie.xml",           "hippie",         {Tags.civilian}),
        prefab_create(Folders.EVGSTORE, "jeansman.xml",         "jeansman",       {Tags.civilian}),
        prefab_create(Folders.EVGSTORE, "jeansman2.xml",        "jeansman2",      {Tags.civilian}),
        prefab_create(Folders.EVGSTORE, "omgamogus.xml",        "omgamogus",      {Tags.creature}),
        -- ["Blindnerd.xml"]    = "Blindnerd.xml",
        -- ["Construction.xml"] = "Construction.xml",
        -- ["EVGSTORE.xml"]     = "EVGSTORE.xml",
        -- ["girl1.xml"]        = "girl1.xml",
        -- ["hippie.xml"]       = "hippie.xml",
        -- ["jeansman.xml"]     = "jeansman.xml",
        -- ["jeansman2.xml"]    = "jeansman2.xml",
        -- ["omgamogus.xml"]    = "omgamogus.xml",
        -- ["gaymanlol.xml"]    = "gaymanlol.xml", --> wtf lol
    }

    PrefabObjects[Folders.FoxyPlayzYT] = {
        prefab_create(Folders.FoxyPlayzYT, "Chris Redfield.xml",          "Chris Redfield",         {Tags.civilian}),
        prefab_create(Folders.FoxyPlayzYT, "Ethan Winters.xml",           "Ethan Winters",          {Tags.civilian}),
        prefab_create(Folders.FoxyPlayzYT, "FoxyPlayzYT.xml",             "FoxyPlayzYT",            {Tags.youtuber}),
        prefab_create(Folders.FoxyPlayzYT, "umbrella corporation1.xml",   "umbrella corporation1",  {Tags.civilian}),
        prefab_create(Folders.FoxyPlayzYT, "umbrella corporation2.xml",   "umbrella corporation2",  {Tags.civilian}),
    }

    PrefabObjects[Folders.idixticlol] = {
        prefab_create(Folders.idixticlol, "gordon.xml",        "gordon",       {Tags.teardown}),
        prefab_create(Folders.idixticlol, "idixticlol.xml",    "idixticlol",   {Tags.military}),
        prefab_create(Folders.idixticlol, "lee.xml",           "lee",          {Tags.teardown}),
        prefab_create(Folders.idixticlol, "lee_jailed.xml",    "lee_jailed",   {Tags.teardown}),
        prefab_create(Folders.idixticlol, "parisa.xml",        "parisa",       {Tags.teardown}),
    }

    PrefabObjects[Folders.Jacob] = {
        prefab_create(Folders.Jacob,    "WW2SovietSoldier.xml",    "WW2SovietSoldier",      {Tags.military}),
        prefab_create(Folders.Jacob,    "WW2SovietTanker.xml",     "WW2SovietTanker",       {Tags.military}),
        -- ["WW2SovietSoldier.xml"] = "WW2SovietSoldier.xml",
        -- ["WW2SovietTanker.xml"]  = "WW2SovietTanker.xml",
    }

    PrefabObjects[Folders.Morvex] = {
        prefab_create(Folders.Morvex,    "female_01.xml",    "female_01",      {Tags.civilian}),
        prefab_create(Folders.Morvex,    "female_02.xml",    "female_02",      {Tags.civilian}),
        prefab_create(Folders.Morvex,    "female_03.xml",    "female_03",      {Tags.civilian}),
        prefab_create(Folders.Morvex,    "female_04.xml",    "female_04",      {Tags.civilian}),
        prefab_create(Folders.Morvex,    "female_05.xml",    "female_05",      {Tags.civilian}),
        prefab_create(Folders.Morvex,    "female_06.xml",    "female_06",      {Tags.civilian}),
        prefab_create(Folders.Morvex,    "finn.xml",         "finn",           {Tags.tvShows}),
        prefab_create(Folders.Morvex,    "lara croft.xml",   "lara croft",     {Tags.tombRaider}),
        prefab_create(Folders.Morvex,    "male_01.xml",      "male_01",        {Tags.civilian}),
        prefab_create(Folders.Morvex,    "male_02.xml",      "male_02",        {Tags.civilian}),
        prefab_create(Folders.Morvex,    "male_03.xml",      "male_03",        {Tags.civilian}),
        prefab_create(Folders.Morvex,    "male_04.xml",      "male_04",        {Tags.civilian}),
        prefab_create(Folders.Morvex,    "male_05.xml",      "male_05",        {Tags.civilian}),
        prefab_create(Folders.Morvex,    "male_06.xml",      "male_06",        {Tags.civilian}),
        prefab_create(Folders.Morvex,    "male_07.xml",      "male_07",        {Tags.civilian}),
        prefab_create(Folders.Morvex,    "male_08.xml",      "male_08",        {Tags.civilian}),
    }

    PrefabObjects[Folders.OffensivePDF] = {
        prefab_create(Folders.OffensivePDF,    "AmbulancePilot.xml",   "AmbulancePilot",   {Tags.emt, Tags.pilot}),
        prefab_create(Folders.OffensivePDF,    "Human3.xml",           "Human3",           {Tags.civilian}),
        prefab_create(Folders.OffensivePDF,    "Human4.xml",           "Human4",           {Tags.civilian}),
        prefab_create(Folders.OffensivePDF,    "Human5.xml",           "Human5",           {Tags.civilian}),
        prefab_create(Folders.OffensivePDF,    "Paramedic.xml",        "Paramedic",        {Tags.emt}),
        prefab_create(Folders.OffensivePDF,    "peachu.xml",           "Peachu",           {Tags.civilian}),
        prefab_create(Folders.OffensivePDF,    "Police.xml",           "Police",           {Tags.police}),
        prefab_create(Folders.OffensivePDF,    "SWAT.xml",             "SWAT",             {Tags.police}),
        prefab_create(Folders.OffensivePDF,    "vox/BusinessMan.xml",  "BusinessMan",      {Tags.civilian, Tags.business}),

    }

    PrefabObjects[Folders.Squareblock] = {
        prefab_create(Folders.Squareblock,    "Astronaut.xml",          "Astronaut",        {Tags.civilian}),
        prefab_create(Folders.Squareblock,    "BlueWhiteShirt.xml",     "BlueWhiteShirt",   {Tags.civilian}),
        prefab_create(Folders.Squareblock,    "Fancy.xml",              "Fancy",            {Tags.civilian}),
        prefab_create(Folders.Squareblock,    "HumanRevamped.xml",      "HumanRevamped",    {Tags.civilian}),
        prefab_create(Folders.Squareblock,    "James.xml",              "James",            {Tags.civilian}),
        prefab_create(Folders.Squareblock,    "Jeremy.xml",             "Jeremy",           {Tags.civilian}),
        prefab_create(Folders.Squareblock,    "Richard.xml",            "Richard",          {Tags.civilian}),
        prefab_create(Folders.Squareblock,    "Stig.xml",               "Stig",             {Tags.tvShows}),
        prefab_create(Folders.Squareblock,    "Swedish police.xml",     "Swedish police",   {Tags.police}),
        prefab_create(Folders.Squareblock,    "WhiteShirtTie.xml",      "WhiteShirtTie",    {Tags.business}),
        prefab_create(Folders.Squareblock,    "WhiteShirtTie2.xml",     "WhiteShirtTie2",   {Tags.business}),
    }

end

function findPrefabObject(path)
    for index, prefab in ipairs(PrefabObjects) do
        DebugWatch("index" .. index, prefab.path)
        -- if prefab.path == path then
        --     return PrefabObjects[index]
        -- end
    end
end
