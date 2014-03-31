module TeamsHelper

  def refresh_team_ratings(team_slug)
    team = Team.find_by_slug(team_slug)
    refresh_ratings(team.players)
  end

  def refresh_ratings(player_list)
    player_list.each do |p|
      p.pull_uscf
      p.pull_live_rating
      p.save
      puts(p.uscf_reg_rating)
    end
  end

  def team(school)
    school.upcase!
    school.slice!(' SCHOOL')
    school.slice!(' ELEMENTARY')
    school.slice!(' MIDDLE')
    school.slice!(' HIGH')
    school.slice!(' MS')
    school.slice!(' HS')
    school.strip!

    {
        'ALAMO HEIGHTS' => 'almhts',
        'ATONEMENT ACADEMY' => 'atonem',
        'BASIS' => 'basis',
        'BEARD' => 'beard',
        'BLATTMAN' => 'blattm',
        'BOB BEARD' => 'beard',
        'BOERNE' => 'boerne',
        'BOERNE CHAMPION' => 'bnchmp',
        'BRANDEIS' => 'brande',
        'BRENNAN' => 'brenn',
        'BRISCOE' => 'brscoe',
        'CASIS' => 'casis',
        'CAMBRIDGE' => 'cambrg',
        'CAMELOT' => 'camelt',
        'CANYON VISTA' => 'cnvist',
        'CANYON' => 'canyon',
        'CCS' => 'corner',
        'CIBOLO' => 'cibolo',
        'CLEAR SPRING' => 'clrspr',
        'CLEARSPRINGS' => 'clrspr',
        'COKER' => 'coker',
        'DAVID BARKLEY/FRANCISCO RUIZ ELEM.' => 'brkriz',
        'DAVID BARKLEY/FRANCISCO RUIZ ELM' => 'brkriz',
        'DE ZAVALA ES' => 'dzvala',
        'DE ZAVALA' => 'dzvala',
        'DISCOVERY' => 'discov',
        'EAST TERRELL HILLS' => 'eterhl',
        'ELSA ENGLAND' => 'englnd',
        'ENCINO PARK ELEM' => 'encino',
        'GARCIA' => 'garcia',
        'GARDEN RIDGE ES' => 'gardrg',
        'GORZYCKI' => 'gorzki',
        'HARMONY HILLS ELEMENTRY' => 'hrmhls',
        'HARMONY' => 'harmny',
        'HARMONY OF INNOVATIONS' => 'hminno',
        'HARRIS' => 'harris',
        'HIDDEN FOREST' => 'hidfst',
        'HOFFMAN' => 'hffman',
        'HOFFMANN LANE' => 'hfmnln',
        'HOFFMANN LANE ELEM.' => 'hfmnln',
        'HOFFMANN' => 'hffman',
        'HOLMES' => 'holmes',
        'HOLMES/BCHS' => 'holmes',
        'HOME' => 'home',
        'HOMESCHOOL' => 'home',
        'HOPE ACADEMY' => 'hope',
        'HUEBNER' => 'huebnr',
        'IDEA CARVER ACADEMY' => 'carver',
        'IDEA CARVER COLLEGE PREP' => 'carver',
        'INDIAN CREEK' => 'ice',
        'ISES' => 'indspr',
        'JAMES CARSON' => 'carson',
        'JAY' => 'jay',
        'JOHN JAY' => 'jay',
        'JOHNSON H.S.' => 'johnsn',
        'JOHNSONSCHOOL' => 'johnsn',
        'JOSE M. LOPEZ' => 'jlopez',
        'KEALING' => 'kealng',
        'KEYSTONE' => 'keystn',
        'KIKER' => 'kiker',
        'KINDER RANCH' => 'kinder',
        'KRUEGER' => 'kruegr',
        'LANGLEY' => 'langle',
        'LAUREL MOUNTAIN' => 'lrlmnt',
        'LEICK' => 'leick',
        'LOS REYES' => 'losrey',
        'LOWELL' => 'lowell',
        'LUNA' => 'luna',
        'MARY LOU HARTMAN' => 'hartmn',
        'MATTHEW' => 'stmatt',
        'MISSION ACADEMY' => 'missac',
        'MONTESORRI OF SAN ANTONIO' => 'montsa',
        'MONTESSORI OF SAN ANTONIO' => 'montsa',
        'MORNINGSIDE' => 'mornsd',
        'NAVARRO' => 'navaro',
        'NICHOLS' => 'nichol',
        'OAK CREEK' => 'oakcrk',
        'OAK MEADOW' => 'oakmdw',
        'OLPH' => 'olph',
        'PEACE CO-OP' => 'peace',
        'PEACE' => 'peace',
        'RALPH LANGLEY' => 'langle',
        'RHODES M.S' => 'rhodes',
        'RHODES' => 'rhodes',
        'ROLLING MEADOWS' => 'rolmdw',
        'RONALD REAGAN' => 'reagan',
        'ROOSEVELT' => 'roosvt',
        'ROY CISNEROS' => 'csnros',
        'SACS' => 'sachrs',
        'SAINT MARY\'S HALL' => 'stmary',
        'SAN ANTONIO ACADEMY' => 'saacad',
        'SAN ANTONIO CHRISTIAN' => 'sachrs',
        'SAM HOUSTON' => 'houston',
        'SCOBEE' => 'scobee',
        'SEGUIN' => 'seguin',
        'SMITHSON VALLEY' => 'smthsv',
        'SVMS' => 'smthsv',
        'SOUTH SAN SHCOOL' => 'sthsan',
        'SOUTH SAN' => 'sthsan',
        'ST MATTHEW CATHOLIC' => 'stmatt',
        'ST. ANTHONY CATHOLIC' => 'stanty',
        'ST. MATTHEW CATHOLIC' => 'stmatt',
        'ST. MATTHEW' => 'stmatt',
        'ST. MATTHEW\'S' => 'stmatt',
        'ST. MATTHEWS CATHOLIC' => 'stmatt',
        'ST. MATTHEWS' => 'stmatt',
        'STEINERRANCH' => 'steinr',
        'STEM ACADEMY AT LEE' => 'stem',
        'STEVENSON' => 'stevsn',
        'TAFT' => 'taft',
        'JOHNSON' => 'johnsn',
        'TEJEDA' => 'tejeda',
        'THE WINSTON' => 'winstn',
        'THOMAS JEFFERSON' => 'tjefhs',
        'TIMBERWOOD PARK ELEMENTART' => 'tmbrwd',
        'TIMBERWOOD PARK' => 'tmbrwd',
        'VALE' => 'vale',
        'VINEYARD RANCH' => 'vineyd',
        'WARD ES' => 'ward',
        'WHITE' => 'white',
        'WHITTIER M.S' => 'whittr',
        'WILDERNESS OAK' => 'wldoak',
        'WILLIAM HOBBY' => 'hobby',
        'WINDCREST' => 'wndcrs'
    }[school]
  end


end
