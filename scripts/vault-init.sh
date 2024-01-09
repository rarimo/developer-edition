#!/usr/bin/env sh

# sendRequest <tss number> <post data>
sendRequest() {
    echo "Adding secrets for tss-$1"
    curl \
        --header "X-Vault-Token: $VAULT_TOKEN" \
        --header "Content-Type: application/json" \
        --request POST \
        --data "$2" \
        http://vault:8200/v1/secret/data/tss${1}
}

tss1_data='{
    "data": {
        "tls": true,
        "data": "",
        "pre": "{\"PaillierSK\":{\"N\":24233259618548607485073179344982653777436594656716685438676983834174655685903398541359777140928702398867345631327120157851948954059064793795082194459973805488736087226021939559155409577145941376637250754362406176750446377612501970845670133841173470711930587977416805006250816335917810504988604005225157889215149174079658449005935230038394642536482737946307109291375948677583887058707573092422492601983082965951270171294537237534321157398153167440615386853017744503862427287120250650373043306583516822641948801083388122218620296512495458052353508139349898574306836674025621019934932185304778001885664856851918869970129,\"LambdaN\":12116629809274303742536589672491326888718297328358342719338491917087327842951699270679888570464351199433672815663560078925974477029532396897541097229986902744368043613010969779577704788572970688318625377181203088375223188806250985422835066920586735355965293988708402503125408167958905252494302002612578944607417815229051401825034823468154124701925147151424400189664914229570921310299043803323569184285299221456723555302012393376758319149660038533234626243482261893355349847543237638427951551626734836993884172082394178382052630940700042245734625578810751418092298076215052562019051046888467116599060378767738924827442,\"PhiN\":24233259618548607485073179344982653777436594656716685438676983834174655685903398541359777140928702398867345631327120157851948954059064793795082194459973805488736087226021939559155409577145941376637250754362406176750446377612501970845670133841173470711930587977416805006250816335917810504988604005225157889214835630458102803650069646936308249403850294302848800379329828459141842620598087606647138368570598442913447110604024786753516638299320077066469252486964523786710699695086475276855903103253469673987768344164788356764105261881400084491469251157621502836184596152430105124038102093776934233198120757535477849654884,\"P\":138220772100464709654609451715158982898742886096264370077347635191341382935397089469252245275284437267875617272448756239394443676179272172052296670858232295980005798721333014775786171452862297874872055188596934426840438074276812505502026500203585216125762554914916957335885809062198325758881960883647137182823,\"Q\":175322849455180646210973650371234149733700757362044541968772583250703055174088396306101988137200085769947443418063694541410075422653818202093837695194988421171721793312442358741354031877184850779308401730002831027674596556818561055382230481524810521996477966680598938560944282465645442928662138432793883132423},\"NTildei\":27295433474409246146408646755051924327018963502870570993548511318382643962543525530841106745450019499870966238368443824442889503124082856883042762924970122250774497607717773900744575922838769758723818113865035013551910953595956484756209964947215938787692014142585385148787215627903356637650726951624693515742182746616692853913660634710316242778209442609056949464042893781913583379261522058831817310696356978563705093576249747145475830659959662811300304333283923042945336654282705077053996770038477038553619684775815518634964114387798686661090539768802047840895634371140978657788270242286709652847909220552742741960857,\"H1i\":5720496949285259615899452867732162379588476961558559768490592669943380918642864338907276526088465540605649606525623412237327515138413022578926295574647525280818297337761758878727396787338720144264218908511388189828827097583994226608447665594315180958373357287159043049734869978285872075982637295264851267833456433446391930029070705175640711455392485836448490770389845251675167383790579433349355003921515746634199432386600682986092677424233878662691047376151850746604925705969669250075981382568144430309176765396398230574374494702294170752707017703607812011660531368975875382788098529627212210256921283115525190861680,\"H2i\":22406393643984078288770170533010792049334569073484965728289725784606089684268220895101328652527517826106760862337609011736918226719869118900058193936484969621389236959370793405646674395166888812600438369899648109228602887794649780498172329029118923469225799427601008686480863555781326870534651755434716546526391609166195411364582241911571158199571475463287953100049197614960562176129360744806885325262620999817175370639242941549601965340022801767729740308552649275482887533739718549295196287717215615853844104076841539094187541064140317548709312821903737676355774344914380642364161902476638949081479129966180543587357,\"Alpha\":14902901587139870693725975321884493029981622971100307478387954819978978077091687215040038857911594298823641253130913881800077302109658283562757450179501296420635398520583953931973429573764550583685862436936032658880868517319722467566180832071443372979199880687795165725436208630389367488684372841982099273303925637553655170732723654339972189949050744312263946949758553250694487988537253147762121453397925007231137582319061750533408641348575930513514845210735757573477001140348781376019246325444304008763107519772467157547537848549356992438649225687950599758395546321333466574487062733806303010641450270268246536094990,\"Beta\":1726081230245707857848017313591010009556476116154894683250592239612281492714377929077620963391270121477520903890598459820582563591767129498024169387452125410151967281111874415561612297871845963233056376450992252439938721572231417421411718105573677712760674602920215122215253727491540903239946231215176793641248618981807635693663868870897931074611420542917489629148186085384724744215995860768306575182477304355637659187090061655712406159336506681938393663336436834464260427972755720398194562845601543598569064449919926567569722564915906764126931556480600835362509459964963826955047705847692272609532428324302414740788,\"P\":83601016671951579627188468519196220660519370232027284982202914598352781268663739903743622365395439076540306236224892885148536017127287846694913393257821720055038142586353157263705987326834633262802845669039028104551150453429562301603598140968890144338068259477884215224734330483705021873618009504340283097799,\"Q\":81624107460067992393179716867071783782908520359490179516807452797198852635054455656614946501465151771970533049511557384153038614724715733385829781828811479776552528936932059726796023656172124963026038966775752426903095114006063582456391147433717593897748273859981724998474935068854000623533249427279934444971}",
        "account": "0x48e605d71caf6f9fb38bcd23bccd80a955340411d00cc2ba402ac7df8a2b0569",
        "trial": "0xcf387fe86c9bb1cf41222cbf47b34a8e58e79bc43a138e44921d64cb9e38e47a"
    }
}'

tss2_data='{
    "data": {
        "tls": true,
        "data": "",
        "pre": "{\"PaillierSK\":{\"N\":22040132970578683506887169642202903627611400939958840097197045007208289268861624286676403906431272889570714277181536437261087151250183868546072440055342681463139379884807156814554175915231913296071217803745740036890191328652331215261384629397763942403738398530105853642231934204841743520231908339904739707695477489506194526690246884962507596201204225237432648607907863974964832475274442583162012945149004990397137075585976456922648027307954595508710909602735549211475568795746701956964906383551832362682741972100579788683909895132107139641832061822615052845869310902291666177782893304301054648253653822749259812412161,\"LambdaN\":11020066485289341753443584821101451813805700469979420048598522503604144634430812143338201953215636444785357138590768218630543575625091934273036220027671340731569689942403578407277087957615956648035608901872870018445095664326165607630692314698881971201869199265052926821115967102420871760115954169952369853847590115551258615713294446467670664888092044182128428846364037025173931722542384048683447045888336529099977589144685088016523018097941390808742932976996997988307694464167765217574361335407326923433311740989687727717915914987994395172598428388632840279823552226144771163438587106602993877445613288667150977137066,\"PhiN\":22040132970578683506887169642202903627611400939958840097197045007208289268861624286676403906431272889570714277181536437261087151250183868546072440055342681463139379884807156814554175915231913296071217803745740036890191328652331215261384629397763942403738398530105853642231934204841743520231908339904739707695180231102517231426588892935341329776184088364256857692728074050347863445084768097366894091776673058199955178289370176033046036195882781617485865953993995976615388928335530435148722670814653846866623481979375455435831829975988790345196856777265680559647104452289542326877174213205987754891226577334301954274132,\"P\":155736006227032968203208914470952415743568904901997550660264862283414982865080899686190455491734820762038154914765962917305749561941813793863831870937534970828580729354905253984773895247727897292257288225199379324695239598791429547772297291473211755069231612152120552598173124218538041117422267159233252219523,\"Q\":141522397450262295454783112695314009276567968273793364519525062333554047324593586108928397880597111435143742381840317972296241550130000097361211777804018264031599138056266267831409817489450618523861201896004953923382825557326919748862907753876160531152974837850003298307545966876528852245004978255724605918507},\"NTildei\":18446129818600856280708550073304342498225644888197776187891262807998411326722543454618306470825530555350458471155786807381276071314899508136060456484677216618799419008401144176611826317355730421310185965646590768833286349732593198121152372764656378129616814153693445009925623220674774116920996294705590504267929451729221036062339917484460440272801702869369137956733422922526141629052785403600847917518914025081725900738797961599567854513555272431908710107646948936753770903882657752453932493918154011445799028795785250565403663126604583927103086309926106954813879900741765838232634803929060135370392556343002120893089,\"H1i\":6438303292953200179291808889803568354465626606626540417016853505713998670245394818533543856049400947865928208862450824021287191074828169680813378964642265078403589630395018918601226418017234830394685036319162274957446299998725541285963625276335349376893254993060364820695128889516415943958802567478096197381945133105283547797890968762422613978263925806284018202166699512556222109822407817439306182190402856547049194769119334349148546476611311507386602694688574242536658627669755352936834824692029181804692992157482545715275709941472610178487428655311968099277457093339250675677844067147694127540657027683919338268456,\"H2i\":14753051031516667683750490530327881819730981581138753062032821421679623630328115527295516207156511694499402967845868891796805387592669337511295295633426038897637424533935774850668773867429332355883184545773082234182051124239686836188254309611285823284615313925224723564967082848758752728318430449019352281503943820945157964614195409984378335549623205240160882768915808363590312323620174809200096827989432505399770887069020924991074361502726681863531080328919763390254553580575251857553589745075685416254409323445073000673770623071659646140654494424549988352274529774416033820773988485238173036519559703431457755288126,\"Alpha\":11347090100546502077897324170106872785032907486166665108956869938445065923956334867758402926403559710082268830353695175407687600313173483896617818696395850167457223889102769623215192343132058369526468717260738962708569079071432020627018663642096112422338739900787530185809209999250432295661401672009231580519186170501293368435939041253666987884535881427594239966180940998786175269165237488423836457783257947520439968137763715063211042733793209444607633371664947527141310614211822965684066859970219275785430663300352996778897260183297165417187415958139090508650877996331273950885760673215816518361425135592993786652963,\"Beta\":3892980957890299962525482315354224687935103276340922744432540755726472292023654216811869786988951193618951707107067401152195280461777751023533652657540121010653299504147294616237500289463831335489229811320320659362140568438376234742830897286432105106696148068079425022817390105845248813196465094393891303383182954041766660939356343577089666990166876501718200563411493364758049032738656855008758635668874834695725273927143706633855269021615589013022496635958572659875536612278502127935262130507271127458985671462278577981829176555779595592252349373011224120353664203461859624579367022739499745195822669230620821120174,\"P\":67642994935923299077608684809749256265431074148879403149662497484518847910413572574110118729136922659742937715202840979007631666604504542413900480898013580169841993211913649668048645583200443584320388348550200244682955495228143654601315549258511712753838113802521427334354833312203361524980634538862507278313,\"Q\":68174575342481744708500469888682977614107415659036920790606411843132218797941016890445661269720318929536633367655671083063968183345914153452537668455146425668746572799988733721599355307497420111875793980668653145972500418155892928976341586408592796906611877795390436980643557470369096863883264894165577521053}",
        "account": "0x4159171c0ce62a9f478d31252d860597612cbd800169062e2e53030576f9308a",
        "trial": "0x2e23ed1c3a0c1f44e26233bc69f7ddcd14caf4718ed33a3f4ef2b5fa883ffb88"
    }
}'

tss3_data='{
    "data": {
        "tls": true,
        "data": "",
        "pre": "{\"PaillierSK\":{\"N\":22762705119223622025539225195917358293073628441367737414022852213690437894090105578392484321048169419715552908279629034226681776940928582406656659565490261930046516613791842299092413835578277895226507800612085533041671605170812401301684797817451245638835734215748353460162427615907246985319558203128572709590250059559162351244373100638363368641161763397412851278115730856231999052146128458665501977883839286351323267908502049527536291008403714969887451865686973930978584092873400981983099261453178354993639539402722742727726277684263687105646862302118381153879137577017522983235412123435321840203240936401109154971401,\"LambdaN\":11381352559611811012769612597958679146536814220683868707011426106845218947045052789196242160524084709857776454139814517113340888470464291203328329782745130965023258306895921149546206917789138947613253900306042766520835802585406200650842398908725622819417867107874176730081213807953623492659779101564286354794973781643172809561272087403745371011839228344930102623478738715562772254705295671198086869236909709089359479309273519101971402999557227737587487120346373084716418590490940144327692311743349191203283379252242109989593614144872709627195402449220387187061050372380303222314016773647927510129798244562371775531402,\"PhiN\":22762705119223622025539225195917358293073628441367737414022852213690437894090105578392484321048169419715552908279629034226681776940928582406656659565490261930046516613791842299092413835578277895226507800612085533041671605170812401301684797817451245638835734215748353460162427615907246985319558203128572709589947563286345619122544174807490742023678456689860205246957477431125544509410591342396173738473819418178718958618547038203942805999114455475174974240692746169432837180981880288655384623486698382406566758504484219979187228289745419254390804898440774374122100744760606444628033547295855020259596489124743551062804,\"P\":140604187527425060304702760779034530815373297008130188413024532647354481279703546043922081967531235245747309319782900947949066945435270606838770339487558562363203688366301895244550414081465886767955793518069752313837492106077872943327535547902761140830161267068009809679920443029055481382399778101148689226199,\"Q\":161892085289307061524223070093592086667933410544515842745228892459100061455833570225406157442488632926856999970172110375644418063853988887873707285506669199182543223525218798083164223885014085819116987380168770434701557288440394907928521855774845638926875565188906728927458133110411338561244669175216914682399},\"NTildei\":23695252137650295255688348878313905338959413037268333270791818585471891125488867696424330324404218307184279357537184750042002777450340880512044394759249494110583742481554611740567713229214868768844647271166637811836943197251034297871407604024357334732962577537581297517108124284324279437143610746915795060942507649493232286087179157198841743979668636949157641344251001981664523742531344319493461693970058027504273139527352105413248820855084121812856538946673358455720566655075655477665841705609128548181544804340145173548068857889118856636897768043280133762436760369810995489322070310936961974220063887759591014550009,\"H1i\":4853469286383755684634960863928327457189003229966562943620219851926566364236132380351004831847207419821587002297124828030397664548168192883513074243963448886505055584835384867780327758840814366286990693399184525272200817225279546159346610455283134338626936760545272356882910006262566754530737233431909436675957364979274599180666430360564839970040587353817841331434411800409514895526947225939310736338924635421161879899600460748002723564095492196245004688149891989625574744242231319801613384047205847728310993426166457956181677570064528358366011803753698233550222138862551672332801014754108277636319375817618237832530,\"H2i\":15560516928985039787629435954632549366415773624811801016178489737319214680787218379159894802355811905761287560130419092432954777203620643332705817057851743418973561298801279195158776833160858015230841556925943510372500605776588421585325072484309765487532875863033203398299050711621483696105488158032675003329905520066507446656842759726827943430663632762735937416319083463982306280663054975747482898964525564682409267939003659855256271109390025087203177926517532269689331990940241356265366502695052112972630205643755033522686378021068232922651713251961843297356595692214936880166589836449103590863605292824644877012470,\"Alpha\":2013083452740927162865831685904443544439391171364944524817776733621393506075456009909201066378310038951788994989184037353872365328391291701846076799206354814070017347833862186490093199231744559762083809946550047228390505643532707658100979334235663901867945333744075609516539662023562593869965331516819720282759851495605589759406112759961487176317774779896943774695990245217192011244420916773831770090845178917492260676405245098818495504604219699011076248611406086793574813918171715056560184797096416320699237354441004341336650279649336486384444071134174837167260203620966857286402102833346597469142206349457871459556,\"Beta\":2918303282553568312135033766596577655147134586039720840187246956493772780621942063538609078951560638364522025040254467738279084383182391253080898952112570027036589263553815345966408139535934688329855538375582601922423249632415245739786580489553518799065638377342395709765289134805529068987868716540821437008530243721795830282842862729867848478959002021309467107132271085516677847833211437281917677721034615194098397053762441578285645819733668663245063097667563500682219667121510103008976260919455475555933784227130289631972489563756244396804996452308232288912327883619008445725452863808370119651873082146105218181987,\"P\":69668742126971268792950414614810147469406212747244215812661339747943021997161970355423922216148768335937110137711396679983019117972086674431212059188767746729192651706737047162464824812149443709393548797941205553149639388147652775866458603286894877480502325160484996604857481178237204868668481898711850616541,\"Q\":85028276003841518000097520015972527494460620394266900187577744356821076587880420485139058417207216908739911387317452700984329015277637841395670257548242831811384400048772462515505586718826811875082198238076127185079988640131807785612380182875374320731431128418819232993889291673659531853962415654134231578861}",
        "account": "0x56733c130cd347aa271bcd30aa1342bccca4795e0bfba5e37036a976acb470dd",
        "trial": "0x9085722cc252de8cdce50990387df6ab04d4e46568f123172d689798626dd7ea"
    }
}'

tss4_data='{
    "data": {
        "tls": true,
        "data": "",
        "pre": "{\"PaillierSK\":{\"N\":25764281288601506683678895460627941815283915710955546258476739018088812286174641264317737860326646836677856152526256415882620496327776829821494096418701523887295210036654725194759151139125989616833378182883335034456393484909353671448475827450752213328567422192306329507063895987723576868179624346080765446151875924806740947995757790183684561972158691085722592752345643900957554515664899757496849819662487233381040174510665939132671603963597881337380224740309850243514793076459043606721022238062688481206698027406770261468415733782268194713113774755063216625451816697324790782144542843165068520215978739616850420622233,\"LambdaN\":12882140644300753341839447730313970907641957855477773129238369509044406143087320632158868930163323418338928076263128207941310248163888414910747048209350761943647605018327362597379575569562994808416689091441667517228196742454676835724237913725376106664283711096153164753531947993861788434089812173040382723075776606578054579704739230269482170739355893678212362151772170390317692261004218196362108362529219744669862706163437505794394073587096537889928066670539464107343486357412566815781065196384034071188048477845093038957880198535580202775522244337339583011286656737022367703787753260693933409114959018226655663330074,\"PhiN\":25764281288601506683678895460627941815283915710955546258476739018088812286174641264317737860326646836677856152526256415882620496327776829821494096418701523887295210036654725194759151139125989616833378182883335034456393484909353671448475827450752213328567422192306329507063895987723576868179624346080765446151553213156109159409478460538964341478711787356424724303544340780635384522008436392724216725058439489339725412326875011588788147174193075779856133341078928214686972714825133631562130392768068142376096955690186077915760397071160405551044488674679166022573313474044735407575506521387866818229918036453311326660148,\"P\":144880963411408204829112754544642008017216517470239934732696588986057139558667769436892376579195001645243376105125175351650780113977362864795285490926900159169257477200049437953299649439634938061356560872470677338681900411101563760267863754447527604278116122187195136658413647036384696399281979146443101792839,\"Q\":177830687220380381450216890175578485429687211827628514068606531336112854097795595335740718024852742396071386078665752192232676675427442692728805908304021869658562884433860537205592195854985400769244510844113506213973436300006225401801422325936522998600387101092860237910622674740817005586778724017095992169247},\"NTildei\":22771961316103242834818781462171181149192439298363803820774621722470966706784234077911737736236943549617517588505591022977603694950380876780659374658191607241512240374102760402121553925909243088393125906506203431499094070193592136835345868001799298657227541790466953550540463467722809253486808749197131970237343356651591330679882179168925851090066571798477693459842925999750987267410107986230345643527266143908515445204400490352831183212560264912133709789264898997570336555308255905332156148840166552880194123096168557363627932689571681697932404438599641309871556547152024719862215809879584456818420385566783549153117,\"H1i\":22602117470430224436584440135792273170576496830064491375579837486097286678675238812614491155398573667023008776936590834684950687219756750629063484140562874307507847609952312751009443338052911521562163361155931032316189962835433707116971931172077214589324028681987309138754703200862801231858699082450842995949737158722120911646122384103385472293439687737614127394076098926108256552829616552397077770755633992216234234164786717183437950077721296413883413805795425296859363793375885344236711165520089149381286226302252228862988147924435804480395541704076622706710221439625742051595506362876061983926593970200151056780629,\"H2i\":20826213247461145394858688778716615401857505475009077076041501478332621236831961509954729304570481167439436726322255833878572283547548809882030912704450309727573826843886489775912888957885071849599415611866646252299510429040510556051952900527994589615436076072347539976588916612397869033778869941616428704713683249855523741833476011151946215275587858959833555850409776688071048603881098628864984742449568161314003543486836856944151036044383596082433377391943338347836787698170094638472087149765467855834553586673812782937187388492451689874401582955509418722865192716622719919088797946128261401919318085824207221469415,\"Alpha\":21970062829534383859750688196943265532080483205835045816507473947885781253309379540031513332365670251111228120963795388031084061045808005423820815431090894841055107153385343747453956539876606181397588692465891987449076671029438201425044828653111895861289842017792201981186450245386234857051891455347370902075709818388542943658299291939439126503395583981526099950891024598928286345166908259140109612844682375982139190146480407942019069945945886635321050142792245936571260162805068599785045641586768751956150833934288670386720147875291858354681839547102172421414256408439068435436205770409938386064047642987590194274239,\"Beta\":3514136102496344594043745173205541624832739731380059104859164999660354879308711629294426194878935612394057014611904440147013271215890320330586126822484549662034552796196783383892264951365896789574535573763983830886787068852816451639915614210834813407475519870266420855513550693892007401622863710534082103538671911491690089299923382480142040182933038984588132577237575297721566127169478463158714099701779311114898570794857881154271674783012212824182066100159426787606692938246807900241492155786730767467443893708620240801390285794199685624928675851430173751884209685121607770385341920318699286783857331847600112700030,\"P\":70941051243451307980324021780770077251893748730681231168519466898141149398695154435248549341384443906219193031614036775885034182996953616816649221818377462712296421083442205342780304642700379989715595573958047386268939956728643195523977705545557128159204264728196891981707746188554941561771744661676868731679,\"Q\":80249590741035721022992019208948909709630672500128118424510650740850561590312474049139326286314050064979942958641732119511833717404585521054208069573624984792267917768972596470833345429223523055429368063136937729483910163165246224101707597955338795186307187081302679079830775237936459559254122167835537999281}",
        "account": "0x64d9d15910050f702da55ad7b07b2caecafa3f7591d7456f7667911d2306b74c",
        "trial": "0x8fffd64693359403da21ac75aca6ed75c69300e31e7efe16dc74d6360abd6adb"
    }
}'

sleep 3 # wait for vault to start
sendRequest 1 "$tss1_data"
sendRequest 2 "$tss2_data"
sendRequest 3 "$tss3_data"
sendRequest 4 "$tss4_data"

tss5='{
  "data": {
    "tls": true,
    "data": "",
    "pre": "{\"PaillierSK\":{\"N\":26546887230486400082914817720568241085808738601861045630724956518771834723145013141506237185468271721823860379555911405778468702571478392523233461650145261578923628369733062236793090151309516324184005717774048181101760351153942190189319272395957873008039478665836628726195610794638699135468934737272507945498096238512889508142522417688447844854644955869533256060882022097384638532084176376512974411793650573924962844725579600096759850693455949569415899557643532245071625990556046901780913058502746921170961450393810590659871961060392394050447959698748886075126014814586978363500622548115518032608986337561249769162037,\"LambdaN\":13273443615243200041457408860284120542904369300930522815362478259385917361572506570753118592734135860911930189777955702889234351285739196261616730825072630789461814184866531118396545075654758162092002858887024090550880175576971095094659636197978936504019739332918314363097805397319349567734467368636253972748884795997153371417139309760409976714110385302081599066076300455545572581341059940540697150469365640391835785588619532578403342038327376532989295466764179682761556221738486857175478280758736404588016971145700800891776473877981452619449621010767268382462695447752392430192230357898663780005469937881017581766438,\"PhiN\":26546887230486400082914817720568241085808738601861045630724956518771834723145013141506237185468271721823860379555911405778468702571478392523233461650145261578923628369733062236793090151309516324184005717774048181101760351153942190189319272395957873008039478665836628726195610794638699135468934737272507945497769591994306742834278619520819953428220770604163198132152600911091145162682119881081394300938731280783671571177239065156806684076654753065978590933528359365523112443476973714350956561517472809176033942291401601783552947755962905238899242021534536764925390895504784860384460715797327560010939875762035163532876,\"P\":152027251364959692528204386664004179235015464781884859064978981692483694242995914931778035957671174609101264873419306495611886118802061740353130110592194276111104347639907462561299275940975549840075126619955922839663509284422184461776121657314885590104402866911818777612760801827551503362593366684502733603363,\"Q\":174619267217805615715593780963887247189169800588173069664442204601009675159060580499802074897248118532190008674921228444341280497999134763084178513522978603437409199439165724868657221044298562154852381482453066036655504020007304349772596019899463720096221052170374725503401030490638969235453095114711872025799},\"NTildei\":27635474264674590917123905704642912599520268761039326014315874839425244918345158598841636176782888905956474557384775813031157186325357634862370302584036068540948327421157641068017426869142290604148491336849762662456024942406442107603127049396895644087915455342266891974888981336304690643859250103826367447484916914714655287152155250209545074409679506373804588943300305483379481579268277682999969061850233165767333004219029357214385067907773698446507251256582907925942167339299009002499770731239462761363714161455642124249532177719885199691729140991765044578052181658237687460922731418147750881664378008100918459033113,\"H1i\":614675289673803487800191143034834836550328498543752377762299221797741091227248039899531954870855216389744225114873861229844181385030080826177512036366990115936565106738145944238679761414727358521869112486220584428532526594864310066580868585908987382481688028581026239612150610951578956836807199110500649086606347447820755094294577932835711642571749700054190160107539947628118479174174817312746919315468644548114319851712506164003626010769280874792387617457675936700724098803142224518690516687431985674232873651669017230239714936750517944343406907530907923832821713598239322599385208363961467975897427528149516211186,\"H2i\":14124618029247900216760858310116877852051587329227812431854229701337313621600357501793060423241653161087730359278260938311965555954468904639511330776090592315096430272188698071104921105645787880843054266759242747079506853831595154948971988001949231942551218142764824289609544272779387808386320088240796791090581481159618891664238101694337296354023122957572209334542012579629377669802348571848627192155400942988183383605199901747097776416493566018655925693987991218058302313348610453144552940264900544752717497315670932839747081539481876787297602622928782991610932225243521488142951551609488415362791726297446956890911,\"Alpha\":11762554638469200344132511027094080627267996593215397843797156672861697031511585923316701432000812053736712515965279958738091888285951017962014884982475156857140340710939047189194836098998656091546448228372179679531090550647378549239642417843295703341014700175091074393554218476203506954255574111587694930327821693782739489017244157553555820056768638702525718724813660414819979538666798365278820066716511003773628896985036405742682618105800460475677637278774126417772974999816614388083064777396163083145521788907583768288796442319997572519020980933363429016140289756417556533613195710151821865988300731299473742246769,\"Beta\":2995793677409743533329213740937719634034340777765576782697655579639145086951338376270782979313145526162358406037124703200578892793981621242835174073666530468641021666504655965388203667715470385935809116122536101703902267690166793096098229347674507112405136038521704055709129840092870670763771392631447737218441211040427519742059590595387072736370869129422378880194260983524713752573129491891831789114786502540041629777312104376096907067672323310662718765323513540384193339708968170318053032316930138726345405492821910144401880329664799850056972947593419154586681717642518479101642271741972818725053589428003405465586,\"P\":84197680342396327857471540710136834797758363596652224511956664307387994939067103040697249835765515071809553717345959874055634594385302060188630642861213290833030546643770424757208306359282877432286790018148448652905950229874937925625338803665129976833887582619106613476066233221607729892860575158765211907349,\"Q\":82055331430429004295300272597200028984841577307815425174862709074913818550991421744829210798695001762051327531041149884903850470089288480111912813108402454045304441245631870748885517082349956917658289565931368756941349830435776908492480589789775858188736075625226945004275701148305202578224844313403658817893}",
    "account": "0x64d9d15910050f702da55ad7b07b2caecafa3f7591d7456f7667911d2306b74c",
    "trial": "0x8fffd64693359403da21ac75aca6ed75c69300e31e7efe16dc74d6360abd6adb"
  }
}'
# sendRequest 5 "$tss5"

echo 'Quit'
