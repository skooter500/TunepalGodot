#include "tunepal.h"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include<string>
#include<ios>

using namespace godot;
using namespace std;

void Tunepal::_bind_methods() {
	ClassDB::bind_method(D_METHOD("say_hello"), &Tunepal::say_hello);
	ClassDB::bind_method(D_METHOD("edSubstring"), &Tunepal::edSubstring);
}

Tunepal::Tunepal() {
	// Initialize any variables here.
	//time_passed = 0.0;
}

Tunepal::~Tunepal() {
	// Add your cleanup here.
}

void Tunepal::_process(double delta) {
	//time_passed += delta;
	//Vector2 new_position = Vector2(10.0 + (10.0 * sin(time_passed * 2.0)), 10.0 + (10.0 * cos(time_passed * 1.5)));
	//set_position(new_position);
}


int Tunepal::edSubstring(const godot::String pattern, const godot::String text, const int thread_id)
{
	int pLength = pattern.length();
	int tLength = text.length();
	int difference = 0;

	char sc;

	if (pLength == 0)
	{
		return 0;
	}
	if (tLength == 0)
	{
		return 0;
	}

	
	// Initialise the first row
	for (int i = 0; i < tLength + 1; i++)
	{
		matrix[0][i] = 0;
	}
	// Now make the first col = 0,1,2,3,4,5,6
	for (int i = 0; i < pLength + 1; i++)
	{
		matrix[i][0] = i;
	}


	for (int i = 1; i <= pLength; i++)
	{
		sc = pattern[i - 1];
		for (int j = 1; j <= tLength; j++)
		{
			int v = matrix[i - 1][j - 1];
			//if ((text.charAt(j - 1) != sc) && (text.charAt(j - 1) != 'Z') && sc != 'Z')                
			if ((text[j - 1] != sc)  && sc != 'Z')
			{
				difference = 1;
			}
			else
			{
				difference = 0;
			}
			matrix[i][j] = UtilityFunctions::min(UtilityFunctions::min(matrix[i - 1][j] + 1, matrix[i][j - 1] + 1), v + difference);
		}
	}
	
		/*
		for (int i = 0 ; i < d.length ; i ++)
	{
		for (int j = 0 ; j < matrix[i].length; j ++)
		{
			System.out.print(matrix[i][j] + "\t");
		}
		System.out.println();
	}
		*/
	int min = matrix[pLength - 1][0];
	for (int i = 0; i < tLength + 1; i++)
	{
		int c = matrix[pLength - 1][i];
		// System.out.println(c);
		if (c < min)
		{
			min = c;
		}
	}
	float ed = min;
	return ed;
}

void Tunepal::say_hello()
{
    UtilityFunctions::print("Hello World");
}
