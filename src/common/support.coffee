moment = require("moment")
ngram = require('ngram-fingerprint')


support =
  fingerprint: (value) ->
    ngram(2, support.normalize(value))

  genres: ["2 Step", "2 Tone", "Aboriginal", "Abstract", "Acapella", "Acid", "Acid House", "Acid Jazz", "Acid Punk", "Acid Rock", "Acid Techno", "Acid Trance", "Acousmatic", "Acoustic", "Adult Contemporary", "African", "African Blues", "African Heavy Metal", "African Hip Hop", "Afro Cuban", "Afro Cuban Jazz", "Afrobeat", "Aggrotech", "Alternative", "Alternative Country", "Alternative Dance", "Alternative Hip Hop", "Alternative Metal", "Alternative Rock", "Ambient", "Ambient Dub", "American Folk Revival", "Americana", "Anarcho Punk", "Andalusian Classical", "Anime", "Anison", "Anti Folk", "Apala", "Arab Pop", "Arena Rock", "Art Rock", "Asian American Jazz", "Asian Underground", "Atlanta Hip Hop", "Audiobook", "Australian Country", "Australian Hip Hop", "Austropop", "Avant Garde Hip Hop", "Avant Garde Jazz", "Avantgarde", "Axé", "Bachata", "Background", "Baila", "Baithak Gana", "Bakersfield Sound", "Ballad", "Baltimore Club", "Banda", "Bangladeshi Classical", "Baroque", "Baroque Pop", "Bass", "Bass Music", "Bassline", "Batucada", "Baul", "Bayou Funk", "Beat", "Beatbox", "Beatdown", "Beautiful", "Bebob", "Bebop", "Beguine", "Benga", "Berlin School", "Bhangra", "Big Band", "Big Beat", "Bikutsi", "Bitpop", "Black Metal", "Blue Eyed Soul", "Bluegrass", "Blues", "Blues Country", "Blues Rock", "Blues Shouter", "Bolero", "Bolero Cubano", "Bollywood", "Bongo Flava", "Boogaloo", "Boogie", "Boogie Woogie", "Boom Bap", "Booty Bass", "Bop", "Bossa Nova", "Bossanova", "Bounce", "Bouncy House", "Bouyon", "Brass & Military", "Brass Band", "Brazilian Rock", "Breakbeat", "Breakcore", "Breaks", "Brega", "Brit Pop", "Britcore", "British Blues", "British Dance Band", "British Folk Revival", "British Hip Hop", "Britpop", "Broken Beat", "Bubblegum Dance", "Bubblegum Pop", "C Pop", "Cabaret", "Cadence Lypso", "Cajun", "Cajun Fiddle Tunes", "Calypso", "Cambodian Classical", "Canadian Blues", "Canterbury Scene", "Cantopop", "Canzone Napoletana", "Cape Jazz", "Carnatic", "Celtic", "Cha Cha", "Cha Cha Cha", "Chalga", "Chamber Jazz", "Chamber Music", "Chanson", "Chap Hop", "Charanga", "Chicago Blues", "Chicago Hip Hop", "Chicano Rap", "Chicha", "Children's", "Chimurenga", "Chinese Classical", "Chinese Rock", "Chiptune", "Choro", "Chorus", "Christian Country", "Christian Gangsta Rap", "Christian Hip Hop", "Christian Pop", "Christian Rap", "Christian Rock", "Chutney", "Chutney Soca", "Classic Country", "Classic Female Blues", "Classic Rock", "Classical", "Classical Crossover", "Close Harmony", "Club", "Club   House", "Comedy", "Comedy Rock", "Compas", "Congolese Rumba", "Conjunto", "Conscious", "Conscious Hip Hop", "Contemporary", "Contemporary Christian", "Contemporary Folk", "Contemporary Jazz", "Contemporary R&B", "Continental Jazz", "Cool Jazz", "Copla", "Corrido", "Cosmic Disco", "Country", "Country Blues", "Country Pop", "Country Rap", "Country Rock", "Coupé Décalé", "Cowboy/Western", "Cowpunk", "Criolla", "Crossover", "Crossover Jazz", "Crunk", "Crunkcore", "Crust", "Cuatro", "Cubano", "Cult", "Cumbia", "Cumbia Rap", "Cut Up/Dj", "Dance", "Dance Hall", "Dance Pop", "Dancehall", "Dangdut", "Dansband", "Danzon", "Dark Ambient", "Dark Cabaret", "Darkcore", "Darkwave", "Death Metal", "Deathrock", "Deep Funk", "Deep House", "Delta Blues", "Descarga", "Desert Rock", "Detroit Blues", "Dialogue", "Disco", "Disco Polo", "Dixieland", "Dj Battle Tool", "Donk", "Doo Wop", "Doom Metal", "Doomcore", "Downtempo", "Dream", "Drill", "Drone", "Drum & Bass", "Drum Solo", "Dub", "Dub Poetry", "Dub Techno", "Dubstep", "Duet", "Early", "East Coast Blues", "East Coast Hip Hop", "Easy Listening", "Ebm", "Education", "Educational", "Electric Blues", "Electro", "Electro House", "Electroacoustic", "Electroclash", "Electronic", "Electronic Rock", "Electronica", "Electronicore", "Electropop", "Elevator", "Emo", "Enka", "Ethereal", "Ethnic", "Ethno Jazz", "Euro Disco", "Euro House", "Euro Techno", "Eurobeat", "Eurodance", "European Free Jazz", "Europop", "Experimental", "Experimental Rock", "Fado", "Fann At Tanbura", "Fast Fusion", "Favela Funk", "Field Recording", "Fijiri", "Filk", "Filmi", "Flamenco", "Folk", "Folk Metal", "Folk Pop", "Folk Rock", "Folklore", "Forró", "Franco Country", "Freak Folk", "Free Funk", "Free Improvisation", "Free Jazz", "Freestyle", "Freestyle Rap", "Frevo", "Fuji", "Funk", "Funk Carioca", "Funk Metal", "Furniture", "Fusion", "Future Jazz", "G Funk", "Gabber", "Gagaku", "Game", "Gamelan", "Gangsta", "Gangsta Rap", "Garage House", "Garage Rock", "Genge", "Ghetto", "Ghetto House", "Ghettotech", "Glam", "Glam Rock", "Glitch", "Go Go", "Goa", "Goa Trance", "Gogo", "Golden Age Hip Hop", "Gospel", "Gospel Blues", "Goth Rock", "Gothic", "Gothic Metal", "Gothic Rock", "Grime", "Grindcore", "Griot", "Grunge", "Guaguancó", "Guaracha", "Gypsy Jazz", "Happy Hardcore", "Hard Bop", "Hard House", "Hard Rock", "Hard Techno", "Hard Trance", "Hardcore", "Hardcore Hip Hop", "Hardcore Metal", "Hardstyle", "Harmonica Blues", "Heavy Metal", "Hellbilly", "Hi Nrg", "Highlife", "Hill Country Blues", "Hindustani", "Hip Hop", "Hip Hop Soul", "Hip House", "Hip Pop", "Hiplife", "Hokum", "Hokum Blues", "Hong Kong English Pop", "Honky Tonk", "Horrorcore", "House", "Huayno", "Humour", "Hyphy", "Idm", "Igbo Highlife", "Igbo Rap", "Illbient", "Impressionist", "Indian Classical", "Indian Pop", "Indie", "Indie Folk", "Indie Pop", "Indie Rock", "Industrial", "Industrial Folk", "Industrial Hip Hop", "Instrumental", "Instrumental Country", "Instrumental Hip Hop", "Instrumental Pop", "Instrumental Rock", "Interview", "Iranian Pop", "Isicathamiya", "Italo Disco", "Italo House", "Italodance", "J Pop", "J Rock", "Jangle Pop", "Jazz", "Jazz Blues", "Jazz Funk", "Jazz Fusion", "Jazz Rap", "Jazz Rock", "Jazz+Funk", "Jazzdance", "Jazzy Hip Hop", "Jibaro", "Jit", "Juke", "Jump Blues", "Jumpstyle", "Jungle", "Junkanoo", "Jùjú", "K Pop", "Kadongo Kamu", "Kansas City Blues", "Kansas City Jazz", "Kapuka", "Karaoke", "Kaseko", "Kayōkyoku", "Keroncong", "Khaliji", "Kizomba", "Klasik", "Klezmer", "Korean Court Music", "Krautrock", "Kuduro", "Kwaito", "Kwassa Kwassa", "Kwela", "Lambada", "Lao Music", "Latin", "Latin Ballad", "Latin Jazz", "Lavani", "Laïkó", "Leftfield", "Livetronica", "Liwa", "Lo Fi", "Louisiana Blues", "Louisiana Swamp Pop", "Lounge", "Lovers Rock", "Low Bap", "Luk Krung", "Luk Thung", "Lyrical Hip Hop", "M Base", "Mainstream Jazz", "Makina", "Makossa", "Maloya", "Mambo", "Mandopop", "Manila Sound", "Maracatu", "Marches", "Mariachi", "Marimba", "Marrabenta", "Math Rock", "Mbalax", "Mbaqanga", "Mbube", "Medieval", "Meditative", "Melodic Hardcore", "Memphis Blues", "Mento", "Merengue", "Merenrap", "Metal", "Metalcore", "Mexican Pop", "Miami Bass", "Middle Of The Road", "Midwest Hip Hop", "Military", "Minimal", "Minimal Techno", "Mizrahi", "Mod", "Modal", "Modal Jazz", "Modern", "Modern Classical", "Modern Electric Blues", "Monolog", "Morlam", "Morna", "Mosambique", "Motswako", "Mouth Music", "Movie Effects", "Mpb", "Mugham", "Music Hall", "Musical", "Musique Concrète", "Méringue", "Música Popular Brasileira", "Música Sertaneja", "Nagoya Kei", "Nashville Sound", "National Folk", "Native Us", "Ndombolo", "Negerpunk", "Neo Bop Jazz", "Neo Classical", "Neo Romantic", "Neo Soul", "Neo Swing", "Neofolk", "Neotraditional Country", "Nerdcore", "Neue Deutsche Härte", "New Age", "New Beat", "New Jack Swing", "New Romanticism", "New School Hip Hop", "New Wave", "No Wave", "Noise", "Noise Rock", "Non Music", "Nordic", "Norteña", "Norteño", "Novelty", "Novelty Ragtime", "Nu Jazz", "Nu Metal", "Nueva Cancion", "Nueva Trova", "Nursery Rhymes", "Oi", "Old School Hip Hop", "Oldies", "Onkyokei", "Opera", "Operatic Pop", "Operetta", "Orchestral Jazz", "Original Pilipino", "Ost", "Other", "Ottoman Classical", "Outlaw Country", "Overtone Singing", "P.Funk", "Pachanga", "Pacific", "Pagode", "Paisley Underground", "Palm Wine", "Parody", "Persian Classical", "Philippine Classical", "Piano Blues", "Piedmont Blues", "Pinoy Pop", "Piobaireachd", "Pipe & Drum", "Plena", "Poetry", "Political", "Political Hip Hop", "Polka", "Polsk Punk", "Pop", "Pop Folk", "Pop Punk", "Pop Rap", "Pop Rock", "Pop Soul", "Pop Sunda", "Pop/Funk", "Porn Groove", "Post Bop", "Post Disco", "Post Modern", "Post Punk", "Post Rock", "Power Ballad", "Power Electronics", "Power Metal", "Power Pop", "Pranks", "Primus", "Prog Rock", "Progressive", "Progressive Bluegrass", "Progressive Country", "Progressive Folk", "Progressive House", "Progressive Pop", "Progressive Rock", "Progressive Trance", "Promotional", "Psy Trance", "Psychadelic", "Psychedelic", "Psychedelic Folk", "Psychedelic Pop", "Psychedelic Rock", "Psychobilly", "Pub Rock", "Public Service Announcement", "Punk", "Punk Blues", "Punk Jazz", "Punk Rock", "Punta", "Punta Rock", "Quechua", "R&B", "Radioplay", "Ragga", "Ragga Hip Hop", "Ragini", "Ragtime", "Ranchera", "Rap", "Rap Opera", "Rap Rock", "Rapcore", "Rapso", "Rasin", "Rave", "Raï", "Rebetiko", "Red Dirt", "Reggae", "Reggae Español/Spanish Reggae", "Reggae Gospel", "Reggae Pop", "Reggaeton", "Religious", "Renaissance", "Retro", "Revival", "Rhythm & Blues", "Rhythm And Blues", "Rhythmic Noise", "Rhythmic Soul", "Rn B/Swing", "Rock", "Rock & Roll", "Rock And Roll", "Rockabilly", "Rocksteady", "Romani", "Romantic", "Roots Reggae", "Rumba", "Rune Singing", "Sakara", "Salsa", "Samba", "Samba Rock", "Satire", "Sawt", "Schlager", "Schranz", "Score", "Screamo", "Screw", "Sega", "Seggae", "Semba", "Sephardic", "Serial", "Sermon", "Sertanejo", "Shangaan Electro", "Shibuya Kei", "Shoegaze", "Showtunes", "Ska", "Ska Jazz", "Skiffle", "Skweee", "Slow Jam", "Slow Rock", "Sludge Metal", "Smooth Jazz", "Soca", "Soft Rock", "Son", "Son Cubano", "Sonata", "Sonero", "Songo", "Songo Salsa", "Sophisti Pop", "Soukous", "Soul", "Soul Blues", "Soul Jazz", "Sound Clip", "Soundtrack", "Southern Hip Hop", "Southern Rock", "Space", "Space Age", "Space Age Pop", "Space Rock", "Spaza", "Special Effects", "Speech", "Speed Garage", "Speed Metal", "Speedcore", "Spoken Word", "St. Louis Blues", "Stage & Screen", "Steel Band", "Stoner Metal", "Stoner Rock", "Story", "Straight Ahead Jazz", "Stride Jazz", "Sufi Rock", "Sung Poetry", "Sunshine Pop", "Surf", "Surf Pop", "Surf Rock", "Swamp Blues", "Swamp Pop", "Swing", "Swingbeat", "Symphonic Rock", "Symphony", "Synth Pop", "Synthpop", "Sámi Music", "Taarab", "Taiwanese Pop", "Tango", "Tech House", "Tech Trance", "Technical", "Techno", "Techno Folk", "Techno Industrial", "Tecnobrega", "Teen Pop", "Tejano", "Terror", "Texas Blues", "Texas Country", "Thai Classical", "Thai Pop", "Theme", "Therapy", "Third Stream", "Thrash", "Thrash Metal", "Thug Rap", "Timba", "Trad Jazz", "Traditional Country", "Traditional Pop", "Trailer", "Trance", "Trap", "Tribal", "Tribal House", "Trip Hop", "Tropicalia", "Trova", "Truck Driving Country", "Turkish Pop", "Turntablism", "Twelve Tone", "Twoubadou", "Uk Garage", "Underground Hip Hop", "Urban Pasifika", "V Pop", "Vallenato", "Vaporwave", "Viking Metal", "Vispop", "Visual Kei", "Vocal", "Vocal Jazz", "West Coast Blues", "West Coast Hip Hop", "West Coast Jazz", "Western Swing", "Witch House", "Wonky Pop", "World", "World Fusion", "Worldbeat", "Zouglou", "Zouk", "Zouk Lambada", "Zydeco", "Éntekhno"]

  normalize: (value) ->
    value
    .replace(/[\_]+/g, ' ') # replace '_' with ' '
    .replace(/\b\s*\&\s*\b/gi, " and ") # replace '&' with 'and'
    .replace(/\b([\.\_\'\-\s]+)n([\.\_\'\-\s])+\b/g, " and ") # replace '-n-' with 'and'
    .replace(/\s+/g, ' ') # multiple spaces with single space
    .replace(/(\([^\)]*\)?)+/gi, '') # strip ()
    .replace(/(\[[^\]]*\]?)+/gi, '') # strip []
    .replace(/^[\_\-\s]+/gi, '') # strip leding non word chars
    .replace(/[\_\-\s]+$/gi, '') # strip trailing non word chars

  querify: (value) ->
    support.normalize(value)

  normalizeAlbumName: (value) ->
    value = support.normalize(value)
    value = value.replace(/([\w\s]+\w)\-[A-Z0-9].+/g, "$1") # Album Name-CATNO Vinyl
    [
      /\b(TRACKFIX|DIRFIX|READ[\-\s]*NFO)\b/gi
      /\d+[\-\s]*(inch|"|i)(\s*vinyl)?/gi
      /\b(CDM|CDEP|CDR|CDS|CD|MCD|DVDA|DVD|TAPE|VINYL|VLS|WEB|SAT|CABLE)\b/g
      /\b(EP|LP|BOOTLEG|SINGLE)\b/gi
      /\b(ADVANCE|PROMO|SAMPLER|PROPER|RERIP|RETAIL|REMIX|BONUS|LTD\.?|LIMITED)\b/gi
      /\b((RE[\-\s]*)?(MASTERED|ISSUE|PACKAGE|EDITION))\b/gi
    ].each (regex) -> value = value.replace(regex, '')

    support.normalize(value)

  normalizeArtistName: (value) ->
    value.split(/\//g).map (v) -> support.normalize(v.replace(/\b(ft|feat|presents)[\_\-\s\.]+.+$/i, ''))

  parseAlbumTags: (value) ->
    regex =
      Vinyl: /\b(VINYL|VLS)\b/i
      CD: /\b(CDM|CDEP|CDR|CDS|CD|MCD)\b/i
      DVD: /\b(DVDA|DVD)\b/i
      Cassette: /\b(TAPE)\b/i
      File: /\b(WEB|SAT)\b/i
      MP3: /\b(WEB|SAT)\b/i
      "Limited Edition": /\b(LTD\.?|LIMITED)\b/i
      Remastered: /\b(REMASTERED)\b/i
      Reissue: /\b(REISSUE)\b/i
      Advance: /\b(ADVANCE)\b/i
      Promo: /\b(PROMO)\b/i
      Rerip: /\b(RERIP)\b/i
      Remix: /\b(REMIX|RMX)\b/i
      Proper: /\b(PROPER)\b/i
      Retail: /\b(RETAIL)\b/i
      Sampler: /\b(SAMPLER)\b/i
      EP: /\b(EP)\b/i
      LP: /\b(LP)\b/i
      Bootleg: /\b(BOOTLEG)\b/i
      Single: /\b(SINGLE|VLS|CDS)\b/i
      Compilation: /^VA-/

    Object.keys(regex).filter (key) -> regex[key].test(value)

  parseGenre: (value) ->
    expected = support.fingerprint(value)
    support.genres.find((g) -> support.fingerprint(g) == expected)

  parseYear: (value) ->
    date = moment(value, "YYYY")
    date.format("YYYY") if date.isValid()

  parseBool: (value) ->
    return null unless value?
    !!value

  parseInt: (value) ->
    return null if support.isEmpty(value)
    result = parseInt(value)
    if result == NaN
    then null
    else result

  parseString: (value) ->
    result = value?.toString().trim()
    if support.isEmpty(result)
    then null
    else result

  parseStringArray: (value) ->
    support.wrapArray(value).map(support.parseString).compact().unique()

  wrapArray: (value) ->
    if Object.isArray(value)
    then value
    else [value]

  isEmpty: (value) ->
    !value? || value.length == 0

  isNotEmpty: (value) ->
    not support.isEmpty(value)

module.exports = support
