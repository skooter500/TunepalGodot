using Godot;
using System;

public partial class edit_distance : Node
{
	int[,] d = new int[301,1001];
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double _delta)
	{
	}
	
	public float edSubstring(string pattern, string text)
	{
		int pLength = pattern.Length;
		int tLength = text.Length;
		int difference = 0;

		char sc;
		
		if (pLength > 300) {
			pLength = 300;
		}
		if (tLength > 1000) {
			tLength = 1000;
		}
		// Initialise the first row
		for (int i = 0; i < tLength + 1; i++)
		{
			d[0,i] = 0;
		}
		// Now make the first col = 0,1,2,3,4,5,6
		for (int i = 0; i < pLength + 1; i++)
		{
			d[i,0] = i;
		}

		for (int i = 1; i <= pLength; i++)
		{
			sc = pattern[i - 1];
			for (int j = 1; j <= tLength; j++)
			{
				int v = d[i - 1,j - 1];
				//if ((text.charAt(j - 1) != sc) && (text.charAt(j - 1) != 'Z') && sc != 'Z')                
				if ((text[j - 1] != sc)  && sc != 'Z')
				{
					difference = 1;
				}
				else
				{
					difference = 0;
				}
				d[i,j] = Mathf.Min(Mathf.Min(d[i - 1,j] + 1, d[i,j - 1] + 1), v + difference);
			}
		}
		
		 /*
		  for (int i = 0 ; i < d.length ; i ++)
		{
			for (int j = 0 ; j < d[i].length; j ++)
			{
				System.out.print(d[i,j] + "\t");
			}
			System.out.println();
		}
		 */
		int min = int.MaxValue;
		for (int i = 0; i < tLength + 1; i++)
		{
			int c = d[pLength,i];
			// System.out.println(c);
			if (c < min)
			{
				min = c;
			}
		}
		int ed = min;
		
		
		/*for (int i = 0; i <= pLength; i++) 
		{
			string line = "";
			for (int j = 0; j <= tLength; j++)
			{
				line += d[i,j] + ", ";
			}
			// GD.Print(line);
		}*/
		//GD.Print((1.0 - (ed / pLength)));
		return ((float)100 * ((float)1.0 - ((float)ed / (float)pLength)));
		
		
	}
	
	
	
	
}
