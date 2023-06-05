extends VBoxContainer

#Placeholder array to debug code, eventually this should come
#from database I think
var songs = ["Brieanna Hurtado", "Landen Larsen", "Travon Couture", "Malorie Dupree", "Colby Sigler", "Shakayla Libby", "Kenya Kovach", "Adan Couture", "Juliet Rafferty", "Jacob Thompson", "Lexus Gant", "Kadin Salgado", "Reid Montez", "Kirstyn Leslie", "Yessenia Delong", "Gaige Atkinson", "Leo Joyce", "Yasmin McMahan", "Frances Bartlett", "Arielle Irwin", "Louise Batista", "Easton Baugh", "Jailyn Vidal", "Kyla Neal", "Leonardo Epstein", "Siobhan Sapp", "Kalli Murry", "Abdullah Burton", "Kendyl Samples", "China Biggs", "Brenden Amador", "Darrin Bobo", "Reanna Greenlee", "Kennedy Welch", "Allysa Lorenz", "Kobi Mattox", "Makiya Marcus", "Codey Gallo", "Alyson Paris", "Taj Crowell", "Nash Elias", "Dylan Langford", "Kade Teague", "Jalin Neumann", "Griffin Barnes", "Terrance Powers", "Sherman Seals", "Jazmyn Waugh", "Scott Newsome", "Ciarra Adamson", "Kaycee Langdon", "Amber Farrington", "Kaytlin Devore", "Meagan Butcher", "Valentina Maxwell", "Misty Paulson", "Easton Lund", "Draven Uribe", "Alivia Ramsey", "Thomas Larue", "Hasan Traylor", "Kristi Carrera", "Vera Mayberry", "Antonio Christian", "Javion Rainey", "Annelise Lowe", "Quentin Valentine", "Ezra Conte", "Joaquin Palermo", "Clarissa Kimbrough", "Mercedez Falk", "Nancy Reinhart", "Miah Shah", "Frankie Helton", "Jenna Maguire", "Linnea Heath", "Galen Gilliam", "Kalvin Betancourt", "Scarlett Mullis", "Earl Kroll", "Kendrick Clancy", "Aubrie Orr", "Allison Sowell", "Markus Amato", "Aliza Mercado", "Viridiana Francois", "Tanisha Yoo", "Giovanna Jaimes", "Casey Maxey", "Dana Carvalho", "Claudia Doran", "Lourdes Cope", "Perla Ponder", "Jesus Gonzalez"]

func _ready():
	var buttons = get_children()
	for button in buttons:
		button.visible = false
	
