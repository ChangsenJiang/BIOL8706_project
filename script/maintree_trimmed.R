library(ape)



tree <- read.tree("D:/naturebird/data/maintree_concan_abbr.tree") 

str(tree)
# Define the list of species to exclude
excluded_species <- c('COLVIR', 'ODOGUJ', 'COTJAP', 'PHACOL', 'MELGAL', 'TYMCUP', 'NUMMEL', 'PENPIL', 
                      'ANSSEM', 'ANSCYG', 'CAIMOS', 'ASASCU', 'ANAPLA', 'ANAZON', 'MELVER', 'DICEXI', 
                      'LEPASP', 'CHLCYA', 'CHLHAR', 'IRECYA', 'PEUTAE', 'PRUFUL', 'PRUHIM', 'PASDOM', 
                      'HYPCIN', 'MOTALB', 'CHLVIR', 'HEMWIL', 'SERCAN', 'LOXCUR', 'LOXLEU', 'RHOROS', 
                      'CALORN', 'EMBFUC', 'PHEMEL', 'CARCAR', 'PASAMO', 'NESACU', 'GEOFOR', 'SPOHYP', 
                      'SPIPAS', 'MELMEL', 'JUNHYE', 'ZONALB', 'SETCOR', 'SETKIR', 'AGEPHO', 'MOLATE', 
                      'QUIMEX', 'UROPYL', 'PLONIG', 'VIDCHA', 'VIDMAC', 'LONSTR', 'TAEGUT', 'BOMGAR', 
                      'PHANIT', 'REGSAT', 'TICMUR', 'SITEUR', 'POLCAE', 'THRLUD', 'CERBRA', 'CERFAM', 
                      'ELAFOR', 'BUPERY', 'TOXRED', 'RHAINO', 'LEUROT', 'STUVUL', 'CINMEX', 'CATFUS', 
                      'CERCOR', 'COPSEC', 'ERIRUB', 'FICALB', 'OENOEN', 'SAXMAU', 'ANTMIN', 'POEATR', 
                      'PARMAJ', 'PSEHUM', 'ALACHE', 'PANBIA', 'NICCHL', 'SYLVIR', 'CISJUN', 'ACRARU', 
                      'HIPICT', 'LOCOCH', 'OXYMAD', 'DONATR', 'HIRRUS', 'PHYTRO', 'RHASIB', 'HYLPRA', 
                      'AEGCAU', 'ERYMCC', 'CETCET', 'HORVUL', 'BRAATR', 'PYCJOC', 'SINWEB', 'SYLATR', 
                      'SYLBOR', 'STEDEN', 'ZOSHYP', 'ZOSLAT', 'PORRUF', 'ILLCLE', 'LEILUT', 'DRYBRU', 
                      'CHAFRE', 'PICGYM', 'CALWIL', 'NOTCIN', 'PTILEU', 'EDOCOE', 'CHAPAP', 'RHIDAH', 
                      'DICMEG', 'MYIHEB', 'STRCIN', 'IFRKOW', 'PARRAG', 'LANLUD', 'APHCOE', 'CORMON', 
                      'CORBRA', 'CORCOR', 'MOHOCH', 'MACNIG', 'GYMTIB', 'RHALEU', 'DRYGAM', 'DYACAS', 
                      'MYSCRO', 'DAPCHR', 'EULNIG', 'ALERUF', 'FALFRO', 'PACPHI', 'ORIORI', 'OREARF', 
                      'PTEMEL', 'ERPZAN', 'VIRALT', 'ORTSPA', 'POSRUF', 'MALELE', 'DASBRO', 'GRAPIC', 
                      'ORISOL', 'PARPUN', 'CLIRUF', 'PTIVIO', 'ATRCLA', 'NEOCOR', 'SAPAEN', 'PITSOR', 
                      'CALVIR', 'SMICAP', 'RHEHOF', 'SAKLUC', 'GRAVAR', 'SCYSUP', 'FORRUF', 'SCLMEX', 
                      'FURFIG', 'CAMPRO', 'XIPELE', 'LEPCOR', 'MANMAN', 'CEPORN', 'PACMIN', 'ONYCOR', 
                      'OXYCRI', 'PIPCHL', 'NEOCIN', 'TACRUB', 'MIOMAC', 'TYRSAV', 'NESNOT', 'EOLROS', 
                      'PROATE', 'AMAGUI', 'AGAROS', 'MELUND', 'HERCAC', 'FALCHE', 'FALPER', 'CARCRI', 
                      'COLSTR', 'LEPDIS', 'APAVIT', 'TROMEL', 'BUCRHI', 'BUCABY', 'RHICYA', 'UPUEPO', 
                      'MERNUB', 'BRALEP', 'EURGUL', 'TODMEX', 'BARMAR', 'CEYCYA', 'CHLAEN', 'HALSEN', 
                      'BUCCAP', 'GALDEA', 'PICPUB', 'INDMAC', 'PSIHAE', 'TRILEU', 'EUBBOU', 'RAMSUL', 
                      'SEMFRA', 'TYTALB', 'GLABRA', 'CICNIG', 'STROCC', 'CATAUR', 'SAGSER', 'PANHAL', 
                      'CIRPEC', 'HALALB', 'HALLEU', 'AQUCHR', 'SPITYR', 'EURHEL', 'RHYJUB', 'GAVSTE', 
                      'APTFOR', 'PYGADE', 'THACHL', 'FREGRA', 'OCEOCE', 'HYDTET', 'FULGLA', 'CALBOR', 
                      'PELURI', 'MESCAY', 'NIPNIP', 'COCCOC', 'EGRGAR', 'BALREX', 'PELCRI', 'SCOUMB', 
                      'FREMAG', 'SULDAC', 'ANHANH', 'ANHRUF', 'PHACAR', 'URIPEL', 'NANHAR', 'NANAUR', 
                      'NANBRA', 'ANTCAR', 'CHOACU', 'STECAR', 'NYCBRA', 'NYCGRA', 'PODSTR', 'AEGBEN', 
                      'CHAPEL', 'HEMCOM', 'CALANN', 'OREMEL', 'BURBIS', 'CHIMIN', 'PLUSOC', 'CHAALE', 
                      'CHAVOC', 'HIMHIM', 'IBISTR', 'LIMLAP', 'AREINT', 'CALPUG', 'PEDTOR', 'THIORB', 
                      'JACJAC', 'NYCSEM', 'ROSBEN', 'TURVEL', 'DROARD', 'GLAPRA', 'RHIAFR', 'STEPAR', 
                      'CEPGRY', 'ALCTOR', 'URILOM', 'URIAAL', 'PHASIM', 'RYNNIG', 'RISTRI', 'CHRMAC', 
                      'LARSMI', 'HELFUL', 'ATLROG', 'ZAPATR', 'ARAGUA', 'BALREG', 'GRUAME', 'PTEBUR', 
                      'PTEGUT', 'SYRPAR', 'ALOBEC', 'CALNIC', 'COLLIV', 'PATFAS', 'CORCRI', 'CORCON', 
                      'ARDKOR', 'CHLMAC', 'GEOCAL', 'CENBEN', 'CENUNI', 'CUCCAN', 'CEUAER', 'PIACAY', 
                      'STRCAM', 'CASCAS', 'DRONOV', 'APTHAA', 'APTOWE', 'APTAUS', 'APTROW', 'RHEAME', 
                      'RHEPEN', 'EUDELE', 'NOTPER', 'NOTORN', 'NOTPEN', 'NOTJUL', 'NOTNIG', 'TINGUT', 
                      'CRYSOU', 'CRYCIN', 'CRYUND')

# exclude selected species
trimmed_tree <- drop.tip(tree, excluded_species)

# plot trimmed tree to check
plot(trimmed_tree)

# Save the trimmed tree to a file
write.tree(trimmed_tree, "D:/naturebird/data/concan_maintree_trimmed.tree")
