function scr_gametext(_text_id)
{
	/*switch(_text_id)
	{
		case "":
			scr_text();
				scr_option();
		break;
	}*/
	switch(_text_id)
	{
		case "1":
			scr_text("Hello, I am a textbox. I display any dialogue in the game, including NPCS, quests, and more!");
				scr_option("WOW!", "2");
				scr_option("Didn't ask", "3");
		break;
		
			case "2": 
				scr_text("That's great that you take so much interest, not many people do.")
				break;
			case "3":
				scr_text("Typical, another textbox hater. Just know, without me, you would be nothing.");
				break;
	}
}