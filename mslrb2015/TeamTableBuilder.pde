import processing.data.JSONArray;
import processing.data.JSONObject;

class TeamTableBuilder {
	private String teamTableSettingsNames[] = {"UnicastAddr", "MulticastAddr", "Team", "longame24", "shortname8"};
	private JSONArray teamSettings;

	TeamTableBuilder(String filename) {
		teamSettings = loadJSONArray(filename);
	} 

	private Table makeTable() {
		Table table = new Table();

		for (String settingsName: teamTableSettingsNames) {
			table.addColumn(settingsName);
		}

		return table;
	}

	private void addTeamSettingToRow(TableRow row, JSONObject teamSetting) {
		for (String settingsName: teamTableSettingsNames) {
			row.setString(settingsName, teamSetting.getString(settingsName));
		}
	}

	Table build() {
		Table table = makeTable();

		for (int i = 0; i < teamSettings.size(); i++) {
			TableRow newRow = table.addRow();

			JSONObject teamSetting = teamSettings.getJSONObject(i);

			addTeamSettingToRow(newRow, teamSetting);
		}

		return table;
	} 
}
