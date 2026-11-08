-- Purpose: select class-appropriate greeting templates without game APIs.
-- Input: public sender class/race tokens; output: twelve templates and a short form.
-- Invariants: no identities, persistence, randomness or shared mutable results.
-- Debug: lua tests/test_greeting_catalog.lua from the project directory.
local _, ns = ...
local Catalog = {COUNT = 12}
ns.GreetingCatalog = Catalog
-- Texts resolve at call time through the locale layer; without it (tests,
-- partial installs) the German key is shown unchanged.
local function L(key)
    local lookup = ns.L
    if lookup then return lookup[key] end
    return key
end
-- K marks a key stored in a file-scope table; it is resolved later with L(...).
local function K(key) return key end

-- The sender's class determines the voice. These are original friendly wishes,
-- not official quotes or claims about specialization, talents or actual power.
-- The two cultural slots are separate so Paladin's twelve base texts stay exact.
local classes = {
    PALADIN = {
        short = K("Licht und Segen, %s!"), gift = K("Licht im Gepäck"), guide = K("einem hellen Segen"),
        templates = {
            K("Das Licht sei mit Euch, %s!"),
            K("Möge Euch ein heller Funke begleiten, %s!"),
            K("Gute Wege und einen sicheren Heimweg, %s!"),
            K("Ein wenig Licht für Euren nächsten Schritt, %s!"),
            K("Möge dieser Segen Euch Zuversicht schenken, %s!"),
            K("Für Euch, %s: Licht im Gepäck und Mut im Herzen!"),
            K("Bleibt behütet, %s, auch auf dunklen Wegen!"),
            K("Eine helle Stunde und gute Gesellschaft wünsche ich Euch, %s!"),
            K("Für die Reise: ein Segen und ein freundlicher Gruß, %s!"),
            K("Möge Euer Weg nach Hause stets beleuchtet sein, %s!"),
            K("Nehmt diesen Funken Zuversicht mit, %s!"),
            K("Auf gute Wege und ein Wiedersehen am Herdfeuer, %s!"),
        },
    },
    PRIEST = {
        short = K("Mut für %s!"), gift = K("Zuversicht im Herzen"), guide = K("festem Willen"),
        templates = {
            K("Einen festen Willen und Zuversicht wünsche ich Euch, %s!"),
            K("Möge Euer Mut auch in stillen Stunden wachsen, %s!"),
            K("Ein wenig Schutz für Euren nächsten Weg, %s!"),
            K("Ruhe im Herzen und Stärke im Geist, %s!"),
            K("Möge Euch die Zuversicht ein guter Begleiter sein, %s!"),
            K("Für Euch, %s: ein klarer Gedanke und neuer Mut!"),
            K("Bleibt standhaft und bewahrt Euren eigenen Weg, %s!"),
            K("Möge Euch ein ruhiger Atem durch den Tag tragen, %s!"),
            K("Für die Reise wünsche ich Euch Kraft und Geborgenheit, %s!"),
            K("Haltet an Eurer Hoffnung fest, %s!"),
            K("Nehmt ein wenig seelische Stärke mit, %s!"),
            K("Auf einen friedlichen Heimweg und ein warmes Herdfeuer, %s!"),
        },
    },
    DRUID = {
        short = K("Natur für %s!"), gift = K("die Kraft der Natur"), guide = K("der Ruhe des Waldes"),
        templates = {
            K("Die Kraft der Natur begleite Euch, %s!"),
            K("Möge Euer Weg so sicher sein wie tiefe Wurzeln, %s!"),
            K("Einen frischen Wind und neuen Mut wünsche ich Euch, %s!"),
            K("Nehmt die Ruhe des Waldes mit auf Eure Reise, %s!"),
            K("Möge Euch die Erde unter den Füßen Halt geben, %s!"),
            K("Für Euch, %s: frisches Grün und einen wachen Sinn!"),
            K("Bleibt behütet unter dem weiten Blätterdach, %s!"),
            K("Möge Euer Mut mit jedem neuen Morgen wachsen, %s!"),
            K("Für die Reise: die Geduld der Bäume und einen freundlichen Gruß, %s!"),
            K("Findet stets einen guten Pfad durch die Wildnis, %s!"),
            K("Nehmt einen Hauch Waldluft und Zuversicht mit, %s!"),
            K("Auf gesunde Wurzeln und ein Wiedersehen am warmen Feuer, %s!"),
        },
    },
    SHAMAN = {
        short = K("Kraft für %s!"), gift = K("die Stärke der Elemente"), guide = K("einem Gruß der Elemente"),
        templates = {
            K("Die Elemente mögen Euch Kraft schenken, %s!"),
            K("Einen festen Stand und günstigen Wind wünsche ich Euch, %s!"),
            K("Möge die Erde Eure Schritte tragen, %s!"),
            K("Nehmt die Wärme eines guten Feuers mit, %s!"),
            K("Möge ein klarer Quell Euren Mut erneuern, %s!"),
            K("Für Euch, %s: die Ruhe der Erde und die Freiheit des Windes!"),
            K("Bleibt standhaft, auch wenn der Wind sich dreht, %s!"),
            K("Möge Euch ein sanfter Wind nach Hause führen, %s!"),
            K("Für die Reise: elementare Kraft und einen freundlichen Gruß, %s!"),
            K("Einen ruhigen Strom und sicheren Boden wünsche ich Euch, %s!"),
            K("Nehmt ein wenig Feuerwärme und Zuversicht mit, %s!"),
            K("Auf gute Wege zwischen Erde, Wasser, Wind und Feuer, %s!"),
        },
    },
    MAGE = {
        short = K("Magie für %s!"), gift = K("ein Funke arkaner Kraft"), guide = K("ruhiger arkaner Kraft"),
        templates = {
            K("Ein Funke arkaner Kraft begleite Euch, %s!"),
            K("Einen klaren Kopf und gute Einfälle wünsche ich Euch, %s!"),
            K("Möge Euch die Magie auf Eurem Weg zur Seite stehen, %s!"),
            K("Nehmt ein wenig arkane Ruhe mit auf die Reise, %s!"),
            K("Möge Eure Neugier stets einen guten Weg finden, %s!"),
            K("Für Euch, %s: ein klarer Gedanke und ein Hauch Magie!"),
            K("Bleibt aufmerksam für die kleinen Wunder am Weg, %s!"),
            K("Möge jeder neue Morgen einen guten Einfall bringen, %s!"),
            K("Für die Reise: arkane Kraft und einen freundlichen Gruß, %s!"),
            K("Einen sicheren Heimweg und einen ruhigen Geist wünsche ich Euch, %s!"),
            K("Nehmt diesen kleinen Funken Zauberkraft mit, %s!"),
            K("Auf gute Wege und anregende Gespräche am Herdfeuer, %s!"),
        },
    },
    WARLOCK = {
        short = K("Kraft für %s!"), gift = K("gezähmte Schattenkraft"), guide = K("Kraft aus dem Dunkel"),
        templates = {
            K("Ein wenig Kraft aus dem Dunkel für Euren Weg, %s!"),
            K("Mögen gezähmte Schatten Euch Zuversicht schenken, %s!"),
            K("Einen festen Willen und einen sicheren Heimweg wünsche ich Euch, %s!"),
            K("Nehmt diesen freundlichen Funken Schattenkraft mit, %s!"),
            K("Möge Euer Mut auch im Unbekannten bestehen, %s!"),
            K("Für Euch, %s: dunkle Kraft mit freundlicher Absicht!"),
            K("Bleibt gelassen, auch wenn der Weg im Schatten liegt, %s!"),
            K("Möge ein ruhiger Geist Euch durch die Dämmerung führen, %s!"),
            K("Für die Reise: gezähmte Magie und einen freundlichen Gruß, %s!"),
            K("Einen klaren Blick und festen Boden wünsche ich Euch, %s!"),
            K("Nehmt ein wenig geheimnisvolle Stärke mit, %s!"),
            K("Auf gute Wege und eine warme Taverne nach Einbruch der Nacht, %s!"),
        },
    },
    WARRIOR = {
        short = K("Mut für %s!"), gift = K("Mut im Herzen"), guide = K("Mut und Standhaftigkeit"),
        templates = {
            K("Mut und Standhaftigkeit seien mit Euch, %s!"),
            K("Einen festen Schritt und ein tapferes Herz wünsche ich Euch, %s!"),
            K("Möge Eure Entschlossenheit Euch sicher tragen, %s!"),
            K("Nehmt ein wenig Zuversicht für den nächsten Weg mit, %s!"),
            K("Möge Euch die Kraft nicht vor dem Heimweg ausgehen, %s!"),
            K("Für Euch, %s: Mut im Herzen und einen sicheren Stand!"),
            K("Bleibt aufrecht und bewahrt Euren guten Willen, %s!"),
            K("Möge ein tiefer Atem Euch neue Stärke geben, %s!"),
            K("Für die Reise: Entschlossenheit und einen freundlichen Gruß, %s!"),
            K("Einen ruhigen Blick und einen festen Griff wünsche ich Euch, %s!"),
            K("Nehmt diesen kleinen Ansporn mit auf Euren Weg, %s!"),
            K("Auf tapfere Schritte und ein Wiedersehen am Herdfeuer, %s!"),
        },
    },
    HUNTER = {
        short = K("Gute Jagd, %s!"), gift = K("den Spürsinn der Wildnis"), guide = K("dem Gespür der Wildnis"),
        templates = {
            K("Das Gespür der Wildnis begleite Euch, %s!"),
            K("Wache Sinne und sichere Pfade wünsche ich Euch, %s!"),
            K("Möge Euch ein günstiger Wind den Weg weisen, %s!"),
            K("Nehmt die Geduld der Wildnis mit auf Eure Reise, %s!"),
            K("Möge Euer Blick auch kleine Wegzeichen finden, %s!"),
            K("Für Euch, %s: einen wachen Sinn und ein ruhiges Händchen!"),
            K("Bleibt aufmerksam auf den Pfaden zwischen Wald und Wiese, %s!"),
            K("Möge jeder neue Morgen eine gute Spur bereithalten, %s!"),
            K("Für die Reise: Spürsinn und einen freundlichen Gruß, %s!"),
            K("Einen trockenen Rastplatz und einen sicheren Heimweg wünsche ich Euch, %s!"),
            K("Nehmt ein wenig Wildnisruhe und Zuversicht mit, %s!"),
            K("Auf gute Fährten und ein warmes Feuer am Ende des Weges, %s!"),
        },
    },
    ROGUE = {
        short = K("Glück, %s!"), gift = K("ein sicheres Händchen"), guide = K("Geschick und einem leisen Schritt"),
        templates = {
            K("Geschick und ein wacher Blick seien mit Euch, %s!"),
            K("Ein sicheres Händchen und gute Gelegenheiten wünsche ich Euch, %s!"),
            K("Möge Euer nächster Schritt gut überlegt sein, %s!"),
            K("Nehmt ein wenig Fingerspitzengefühl mit auf die Reise, %s!"),
            K("Möge Euer Gespür Euch stets den passenden Weg zeigen, %s!"),
            K("Für Euch, %s: einen leisen Schritt und einen klaren Kopf!"),
            K("Bleibt flink und bewahrt Euren guten Humor, %s!"),
            K("Möge Euch ein kluger Einfall im rechten Augenblick finden, %s!"),
            K("Für die Reise: Geschick und einen freundlichen Gruß, %s!"),
            K("Einen sicheren Tritt und einen entspannten Heimweg wünsche ich Euch, %s!"),
            K("Nehmt diesen kleinen Schub Zuversicht mit, %s!"),
            K("Auf geschickte Schritte und einen gemütlichen Platz am Herdfeuer, %s!"),
        },
    },
}

-- These gentle cultural accents describe the sender's fantasy voice, never the
-- recipient's beliefs or gender. Every pair combines with the selected class;
-- e.g. Tauren/DRUID keeps nature and roots, Tauren/SHAMAN keeps elements and earth.
local races = {
    Human = {gift = K("Zuversicht für den Heimweg"), path = K("auf den Straßen der Heimat")},
    Dwarf = {gift = K("die Ruhe tiefer Berge"), path = K("über Stein und Bergpfade")},
    NightElf = {gift = K("die Stille des Mondwaldes"), path = K("unter dem Mond zwischen alten Bäumen")},
    Gnome = {gift = K("ein guter Einfall zur rechten Zeit"), path = K("auf erfinderischen Wegen zu neuen Zielen")},
    Draenei = {gift = K("Hoffnung auf ein neues Morgen"), path = K("auf der Suche nach einer guten Heimstatt")},
    Orc = {gift = K("den Mut der Ahnen"), path = K("auf den Spuren der Ahnen")},
    Scourge = {gift = K("Mut für einen neuen Anfang"), path = K("auf Eurem eigenen Weg in die Zukunft")},
    Tauren = {gift = K("die Geduld tiefer Wurzeln"), path = K("über die weite Erde")},
    Troll = {gift = K("das Geleit freundlicher Geister"), path = K("im Takt der Trommeln")},
    BloodElf = {gift = K("die Ruhe alter Gärten"), path = K("durch die Gärten der Heimat")},
}

-- Unknown sender classes get a genuinely neutral voice. Missing metadata must
-- never silently turn a Druid or an unfamiliar future class into a Paladin.
local neutral = {
    short = K("Gute Wege, %s!"),
    templates = {
        K("Gute Wege, %s!"),
        K("Einen sicheren Heimweg wünsche ich Euch, %s!"),
        K("Möge Euch die Zuversicht auf Eurer Reise begleiten, %s!"),
        K("Ein freundlicher Gruß für Euren nächsten Schritt, %s!"),
        K("Möge Euer Tag gute Begegnungen bereithalten, %s!"),
        K("Für Euch, %s: neuen Mut und einen klaren Kopf!"),
        K("Bleibt wohlauf, wohin Euer Weg Euch auch führt, %s!"),
        K("Eine ruhige Stunde und gute Gesellschaft wünsche ich Euch, %s!"),
        K("Für die Reise: einen guten Wunsch und einen freundlichen Gruß, %s!"),
        K("Möge Euch am Ende des Tages ein warmer Rastplatz erwarten, %s!"),
        K("Nehmt ein wenig Zuversicht mit, %s!"),
        K("Auf einen guten Weg und ein Wiedersehen am Feuer, %s!"),
    },
}

-- Return a detached table, so callers can choose or inspect text without ever
-- changing the shared catalog. Only exact public tokens select an entry; no
-- coercion, user metatable, game API, random generator or persistent state runs.
-- Short forms contain <=32 UTF-8 bytes including %s. Two 96-byte names, the
-- addon prefix and quotation punctuation still fit inside the 255-byte budget.
function Catalog.Select(senderClass, senderRace)
    local style = type(senderClass) == "string" and classes[senderClass] or nil
    local race = type(senderRace) == "string" and races[senderRace] or nil
    local source, result = style or neutral, {}
    for index = 1, Catalog.COUNT do result[index] = L(source.templates[index]) end
    if style and race then
        -- The composed slots keep a literal %s for the recipient; the fragments
        -- are resolved first so each language can order them its own way.
        result[6] = L("Für Euch, %%s: %s und %s!"):format(L(style.gift), L(race.gift))
        result[12] = L("Mit %s %s, %%s!"):format(L(style.guide), L(race.path))
    end
    return result, L(source.short)
end
