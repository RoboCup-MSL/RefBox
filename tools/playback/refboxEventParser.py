# 2016-11-29 Edwin Schreuder - creation
#
# Description: Parses refbox event logs to python dictionary
# 

class refboxEventParser():

	def __init__(self):
		pass

	def load(self, filename):
		with open(filename, 'r') as f:
			data = self.loads(f.read())

		return data

	def loads(self, data):
		eventLines = data.splitlines()

		eventLines = self._removeBogusLines(eventLines)
		data = self._interpretEvents(eventLines)

		return data

	def _removeBogusLines(self, eventLines):
		newEventLines = []
		for line in eventLines:
			isLineCorrect = False
			lineSegments = line.split(",")
			
			if (len(lineSegments) == 5):
				try:
					int(lineSegments[0])
					isLineCorrect = True
				except ValueError:
					pass
			
			if isLineCorrect:
				newEventLines.append(line)
			
		return newEventLines
	
	def _interpretEvents(self, eventLines):
		data = []
		
		for line in eventLines:
			lineSegments = line.split(",")

			entry = {}
			entry["timestamp"] = int(lineSegments[0])
			entry["gameTime"] = lineSegments[1]
			entry["phase"] = lineSegments[2]
			(team, event) = self._stringToTeamAndEvent(lineSegments[3])
			entry["event"] = event
			entry["team"] = team
			
			data.append(entry)
			
		return data
			
	def _stringToTeamAndEvent(self, string):
		team = ""

		if (string == "s"):
			event = "START"
		elif (string == "S"):
			event = "STOP"
		elif (string == "1"):
			event = "1st half"
		elif (string == "2"):
			event = "2nd half"
		elif (string == "3"):
			event = "Overtime 1st half"
		elif (string == "4"):
			event = "Overtime 2nd half"
		elif (string == "h"):
			event = "Halftime"
		elif (string == "e"):
			event = "End Game"
		elif (string == "Z"):
			event ="Reset Game"
		else:
			if string.isupper():
				team = "MAGENTA"
			else:
				team = "CYAN"

			string = string.upper()

			if (string == "G"):
				event = "Goalkick"	
			elif (string == "F"):
				event = "Freekick"
			elif (string == "K"):
				event = "Kickoff"
			elif (string == "T"):
				event = "Throw in"
			elif (string == "P"):
				event = "Penalty"
			elif (string == "A"):
				event = "Goal+"
			elif (string == "R"):
				event = "Red card"
			else:
				raise ValueError("Could not parse " + string)
				
		return (team, event)
		
