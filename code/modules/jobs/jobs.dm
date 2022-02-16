GLOBAL_LIST_INIT(command_positions, list(
	"Captain",
	"Head of Personnel",
	"Head of Security",
	"Chief Engineer",
	"Research Director",
	"Chief Medical Officer"))


GLOBAL_LIST_INIT(engineering_positions, list(
	"Chief Engineer",
	"Station Engineer",
	"Mechanic",
	"Atmospheric Technician"))


GLOBAL_LIST_INIT(medical_positions, list(
	"Chief Medical Officer",
	"Medical Doctor",
	"Paramedic",
	"Virologist",
	"Chemist",
	"Field Medic"))


GLOBAL_LIST_INIT(science_positions, list(
	"Research Director",
	"Scientist",
	"Exploration Crew",
	"Geneticist",
	"Roboticist"))


GLOBAL_LIST_INIT(supply_positions, list(
	"Quartermaster",
	"Cargo Technician",
	"Shaft Miner",
	"Hunter"))


GLOBAL_LIST_INIT(service_positions, list(
	"Trader",
	"Head of Personnel",
	"Bartender",
	"Botanist",
	"Cook",
	"Janitor",
	"Curator",
	"Psychologist",
	"Lawyer",
	"Chaplain",
	"Clown",
	"Mime",
	"Assistant"))

//we really need to split service into civillian positions officially, until then this is my solution
GLOBAL_LIST_INIT(service_food_positions, list(
	"Bartender",
	"Botanist",
	"Cook",
))

GLOBAL_LIST_INIT(security_positions, list(
	"Head of Security",
	"Warden",
	"Detective",
	"Security Officer",
	"Russian Officer",
	"Veteran",
	"Field Medic"))

GLOBAL_LIST_INIT(scum_positions, list(
	"Bomj",
	"Prisoner"))

GLOBAL_LIST_INIT(nonhuman_positions, list(
	"AI",
	"Cyborg",
	ROLE_ICECREAM))

// job categories for rendering the late join menu
GLOBAL_LIST_INIT(position_categories, list(
	EXP_TYPE_COMMAND = list("jobs" = command_positions, "color" = "#5555ff", "runame" = "Командование"),
	EXP_TYPE_ENGINEERING = list("jobs" = engineering_positions, "color" = "#ff9944", "runame" = "Инженерный"),
	EXP_TYPE_SUPPLY = list("jobs" = supply_positions, "color" = "#9999ff", "runame" = "Снабжение"),
	EXP_TYPE_SILICON = list("jobs" = nonhuman_positions - "pAI", "color" = "#44ff44", "runame" = "Синтетики"),
	EXP_TYPE_SERVICE = list("jobs" = service_positions, "color" = "#449291", "runame" = "Обслуга"),
	EXP_TYPE_MEDICAL = list("jobs" = medical_positions, "color" = "#ff44a0", "runame" = "Медицинский"),
	EXP_TYPE_SCIENCE = list("jobs" = science_positions, "color" = "#ff44ff", "runame" = "Научный"),
	EXP_TYPE_SECURITY = list("jobs" = security_positions, "color" = "#ff4444", "runame" = "Охрана"),
	EXP_TYPE_SCUM = list("jobs" = scum_positions, "color" = "#3af779", "runame" = "Гости")
))

GLOBAL_LIST_INIT(exp_jobsmap, list(
	EXP_TYPE_CREW = list("titles" = command_positions | engineering_positions | medical_positions | science_positions | supply_positions | security_positions | service_positions | scum_positions | list("AI","Cyborg")), // crew positions
	EXP_TYPE_COMMAND = list("titles" = command_positions),
	EXP_TYPE_ENGINEERING = list("titles" = engineering_positions),
	EXP_TYPE_MEDICAL = list("titles" = medical_positions),
	EXP_TYPE_SCIENCE = list("titles" = science_positions),
	EXP_TYPE_SUPPLY = list("titles" = supply_positions),
	EXP_TYPE_SECURITY = list("titles" = security_positions),
	EXP_TYPE_SILICON = list("titles" = list("AI","Cyborg")),
	EXP_TYPE_SERVICE = list("titles" = service_positions),
	EXP_TYPE_SCUM = list("titles" = scum_positions)
))

GLOBAL_LIST_INIT(exp_specialmap, list(
	EXP_TYPE_LIVING = list(), // all living mobs
	EXP_TYPE_ANTAG = list(),
	EXP_TYPE_SPECIAL = list("Lifebringer","Ash Walker","Exile","Servant Golem","Free Golem","Hermit","Translocated Vet","Escaped Prisoner","Hotel Staff","SuperFriend","Space Syndicate","Ancient Crew","Space Doctor","Space Bartender","Beach Bum","Skeleton","Zombie","Space Bar Patron","Lavaland Syndicate","Ghost Role"), // Ghost roles
	EXP_TYPE_GHOST = list() // dead people, observers
))
GLOBAL_PROTECT(exp_jobsmap)
GLOBAL_PROTECT(exp_specialmap)

//this is necessary because antags happen before job datums are handed out, but NOT before they come into existence
//so I can't simply use job datum.department_head straight from the mind datum, laaaaame.
/proc/get_department_heads(job_title)
	if(!job_title)
		return list()

	for(var/datum/job/J in SSjob.occupations)
		if(J.title == job_title)
			return J.department_head //this is a list

/proc/get_full_job_name(job)
	var/static/regex/cap_expand = new("cap(?!tain)")
	var/static/regex/cmo_expand = new("cmo")
	var/static/regex/hos_expand = new("hos")
	var/static/regex/hop_expand = new("hop")
	var/static/regex/rd_expand = new("rd")
	var/static/regex/ce_expand = new("ce")
	var/static/regex/qm_expand = new("qm")
	var/static/regex/int_expand = new("(?<!security )officer")
	var/static/regex/rus_expand = new("(?<!russian )officer")
	var/static/regex/vet_expand = new("veteran")
	var/static/regex/engi_expand = new("(?<!station )engineer")
	var/static/regex/atmos_expand = new("atmos tech")
	var/static/regex/doc_expand = new("(?<!medical )doctor|medic(?!al)")
	var/static/regex/mine_expand = new("(?<!shaft )miner")
	var/static/regex/chef_expand = new("chef")
	var/static/regex/borg_expand = new("(?<!cy)borg")

	job = lowertext(job)
	job = cap_expand.Replace(job, "captain")
	job = cmo_expand.Replace(job, "chief medical officer")
	job = hos_expand.Replace(job, "head of security")
	job = hop_expand.Replace(job, "head of personnel")
	job = rd_expand.Replace(job, "research director")
	job = ce_expand.Replace(job, "chief engineer")
	job = qm_expand.Replace(job, "quartermaster")
	job = int_expand.Replace(job, "security officer")
	job = rus_expand.Replace(job, "russian officer")
	job = vet_expand.Replace(job, "veteran")
	job = engi_expand.Replace(job, "station engineer")
	job = atmos_expand.Replace(job, "atmospheric technician")
	job = doc_expand.Replace(job, "medical doctor")
	job = mine_expand.Replace(job, "shaft miner")
	job = chef_expand.Replace(job, "cook")
	job = borg_expand.Replace(job, "cyborg")
	return job
