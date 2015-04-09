fingerprint = require('ngram-fingerprint')

match = (array) ->
  (a) -> array.find((b) -> fingerprint(2, a) == fingerprint(2, b))

module.exports =
  names: [
    "Aboriginal", "Abstract", "Acapella", "Acid", "Acid House", "Acid Jazz", "Acid Punk", "Acid Rock", "Acoustic", "African", "Afro-Cuban", "Afro-Cuban Jazz", "Afrobeat", "Alternative", "Alternative Rock", "Ambient",
    "Andalusian Classical", "Anime", "Arena Rock", "Art Rock", "Audiobook", "Avant-garde Jazz", "Avantgarde", "Axé", "Bachata", "Ballad", "Baltimore Club", "Bangladeshi Classical", "Baroque", "Bass", "Bass Music",
    "Bassline", "Batucada", "Bayou Funk", "Beat", "Beatbox", "Beatdown", "Bebob", "Beguine", "Berlin-School", "Bhangra", "Big Band", "Big Beat", "Black Metal", "Bluegrass", "Blues", "Blues Rock", "Bolero",
    "Bollywood", "Bongo Flava", "Boogaloo", "Boogie", "Boogie Woogie", "Boom Bap", "Booty Bass", "Bop", "Bossa Nova", "Bossanova", "Bounce", "Brass & Military", "Brass Band", "Breakbeat", "Breakcore", "Breaks",
    "Brit Pop", "BritPop", "Britcore", "Broken Beat", "Cabaret", "Cajun", "Calypso", "Cambodian Classical", "Canzone Napoletana", "Cape Jazz", "Carnatic", "Celtic", "Cha-Cha", "Chamber Music", "Chanson", "Charanga",
    "Chicago Blues", "Children's", "Chinese Classical", "Chiptune", "Chorus", "Christian Gangsta Rap", "Christian Rap", "Christian Rock", "Classic Rock", "Classical", "Club", "Club - House", "Comedy", "Compas",
    "Conjunto", "Conscious", "Contemporary", "Contemporary Christian", "Contemporary Jazz", "Contemporary R&B", "Cool Jazz", "Copla", "Corrido", "Country", "Country Blues", "Country Rock", "Crossover", "Crunk",
    "Crust", "Cuatro", "Cubano", "Cult", "Cumbia", "Cut-up/DJ", "DJ Battle Tool", "Dance", "Dance Hall", "Dance-pop", "Dancehall", "Danzon", "Dark Ambient", "Darkwave", "Death Metal", "Deathrock", "Deep House",
    "Delta Blues", "Descarga", "Dialogue", "Disco", "Dixieland", "Donk", "Doo Wop", "Doom Metal", "Doomcore", "Downtempo", "Dream", "Drone", "Drum & Bass", "Drum Solo", "Drum n Bass", "Dub", "Dub Poetry",
    "Dub Techno", "Dubstep", "Duet", "EBM", "Early", "East Coast Blues", "Easy Listening", "Education", "Educational", "Electric Blues", "Electro", "Electro House", "Electroclash", "Electronic", "Emo", "Enka",
    "Ethereal", "Ethnic", "Euro House", "Euro-Disco", "Euro-House", "Euro-Techno", "Eurobeat", "Eurodance", "Europop", "Experimental", "Fado", "Fast Fusion", "Favela Funk", "Field Recording", "Flamenco", "Folk",
    "Folk Metal", "Folk Rock", "Folk-Rock", "Folklore", "Forró", "Free Funk", "Free Improvisation", "Free Jazz", "Freestyle", "Funk", "Funk Metal", "Fusion", "Future Jazz", "G-Funk", "Gabber", "Gagaku", "Game",
    "Gamelan", "Gangsta", "Garage House", "Garage Rock", "Ghetto", "Ghetto House", "Ghettotech", "Glam", "Glitch", "Go-Go", "Goa", "Goa Trance", "Gogo", "Gospel", "Goth Rock", "Gothic", "Gothic Metal", "Gothic Rock",
    "Grime", "Grindcore", "Griot", "Grunge", "Guaguancó", "Guaracha", "Gypsy Jazz", "Happy Hardcore", "Hard Bop", "Hard House", "Hard Rock", "Hard Techno", "Hard Trance", "Hardcore", "Hardcore Hip-Hop",
    "Hardcore Metal", "Hardstyle", "Harmonica Blues", "Heavy Metal", "Hi NRG", "Highlife", "Hindustani", "Hip Hop", "Hip-Hop", "Hip-House", "Hiplife", "Honky Tonk", "Horrorcore", "House", "Humour", "Hyphy", "IDM",
    "Illbient", "Impressionist", "Indian Classical", "Indie", "Indie Pop", "Indie Rock", "Industrial", "Instrumental", "Instrumental Pop", "Instrumental Rock", "Interview", "Italo House", "Italo-Disco", "Italodance",
    "J-pop", "JPop", "Jazz", "Jazz+Funk", "Jazz-Funk", "Jazz-Rock", "Jazzdance", "Jazzy Hip-Hop", "Jibaro", "Juke", "Jump Blues", "Jumpstyle", "Jungle", "Junkanoo", "Karaoke", "Kaseko", "Klasik", "Klezmer",
    "Korean Court Music", "Krautrock", "Kwaito", "Lambada", "Lao Music", "Latin", "Latin Jazz", "Laïkó", "Leftfield", "Lo-Fi", "Louisiana Blues", "Lounge", "Lovers Rock", "Luk Thung", "MPB", "Makina", "Mambo",
    "Marches", "Mariachi", "Marimba", "Math Rock", "Medieval", "Meditative", "Melodic Hardcore", "Mento", "Merengue", "Metal", "Metalcore", "Miami Bass", "Military", "Minimal", "Minimal Techno", "Mizrahi", "Mod",
    "Modal", "Modern", "Modern Classical", "Modern Electric Blues", "Monolog", "Motswako", "Mouth Music", "Movie Effects", "Mugham", "Music Hall", "Musical", "Musique Concrète", "National Folk", "Native US",
    "Negerpunk", "Neo Soul", "Neo-Classical", "Neo-Romantic", "Neofolk", "New Age", "New Beat", "New Jack Swing", "New Wave", "No Wave", "Noise", "Noise Rock", "Non-Music", "Nordic", "Norteño", "Novelty", "Nu Metal",
    "Nueva Cancion", "Nueva Trova", "Nursery Rhymes", "OST", "Oi", "Oldies", "Opera", "Operetta", "Other", "Ottoman Classical", "Overtone Singing", "P.Funk", "Pachanga", "Pacific", "Parody", "Persian Classical",
    "Philippine Classical", "Piano Blues", "Piedmont Blues", "Piobaireachd", "Pipe & Drum", "Plena", "Poetry", "Political", "Polka", "Polsk Punk", "Pop", "Pop Punk", "Pop Rap", "Pop Rock", "Pop-Folk", "Pop/Funk",
    "Porn Groove", "Post Bop", "Post Rock", "Post-Modern", "Post-Punk", "Power Ballad", "Power Electronics", "Power Metal", "Power Pop", "Pranks", "Primus", "Prog Rock", "Progressive House", "Progressive Rock",
    "Progressive Trance", "Promotional", "Psy-Trance", "Psychadelic", "Psychedelic", "Psychedelic Rock", "Psychobilly", "Pub Rock", "Public Service Announcement", "Punk", "Punk Rock", "Quechua", "R&B", "Radioplay",
    "Ragga", "Ragga HipHop", "Ragtime", "Ranchera", "Rap", "Rapso", "Rave", "Raï", "Rebetiko", "Reggae", "Reggae Gospel", "Reggae-Pop", "Reggaeton", "Religious", "Renaissance", "Retro", "Revival", "Rhythm & Blues",
    "Rhythmic Noise", "Rhythmic Soul", "RnB/Swing", "Rock", "Rock & Roll", "Rockabilly", "Rocksteady", "Romani", "Romantic", "Roots Reggae", "Rumba", "Rune Singing", "Salsa", "Samba", "Satire", "Schlager", "Schranz",
    "Score", "Screw", "Sephardic", "Serial", "Sermon", "Shoegaze", "Showtunes", "Ska", "Skiffle", "Skweee", "Slow Jam", "Slow Rock", "Sludge Metal", "Smooth Jazz", "Soca", "Soft Rock", "Son", "Sonata", "Sonero",
    "Soukous", "Soul", "Soul-Jazz", "Sound Clip", "Soundtrack", "Southern Rock", "Space", "Space Rock", "Space-Age", "Spaza", "Special Effects", "Speech", "Speed Garage", "Speed Metal", "Speedcore", "Spoken Word",
    "Stage & Screen", "Steel Band", "Stoner Metal", "Stoner Rock", "Story", "Surf", "Swamp Pop", "Swing", "Swingbeat", "Symphonic Rock", "Symphony", "Synth-pop", "Synthpop", "Sámi Music", "Tango", "Tech House",
    "Tech Trance", "Technical", "Techno", "Techno-Industrial", "Tejano", "Terror", "Texas Blues", "Thai Classical", "Theme", "Therapy", "Thrash", "Thrash Metal", "Thug Rap", "Timba", "Trailer", "Trance",
    "Trap", "Tribal", "Tribal House", "Trip Hop", "Trip-Hop", "Trova", "Turntablism", "Twelve-tone", "UK Garage", "Vallenato", "Vaporwave", "Viking Metal", "Vocal", "Witch House", "World", "Zouk", "Zydeco", "Éntekhno"
  ]

  match: (array = []) ->
    array.map((a) => match(@names)(a)).compact()
