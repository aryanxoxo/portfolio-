/*
 File:          mazesolver.c
 Purpose:       This mazesolver solution will parse through the solution using a depth first search algorithm with a heavy emphesis on recursion.
 Author:		Aryan Chahardovalee & Siddharth Chadha
 Student #s:	55476444 and 99732539
 CS Accounts:	e0e2b and V7k2b
 Date:			November 8th, 2019
 */


 /******************************************************************
  PLEASE EDIT THIS FILE

  Comments that start with // should be replaced with code
  Comments that are surrounded by * are hints
  ******************************************************************/

#define _CRT_SECURE_NO_WARNINGS

  /* Preprocessor directives to include libraries */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "mazesolver.h"

/*
 Main function drives the program.
 PRE:       The file specified by the MACRO in line 44 exists in the project
 POST:      Prints data about maze solutions.
 RETURN:    IF the program exits correctly
			THEN 0 ELSE 1
 */
int main(void) {
	/* Variables */
	int          dimension = 0;
	int          error = 0;
	int          start_row = 0;
	int			 start_col = 0;
	FILE* maze_file = NULL;
	maze_cell** maze = NULL;

	/* Initializes the global variables */
	paths = NULL;
	paths_found = 0;


	/* Opens and parses the maze file.  Replace the 2nd parameter of fopen_s with
	   different file names defined in the preprocessor section of the header file
	   to test your mazesolver with our sample mazes. */
	error = fopen_s(&maze_file, MAZE1, "r");
	if (error) {
		fprintf(stderr, "Unable to open file: %s\n", MAZE3);
		system("pause");
		return 1;
	}

	if (maze_file) {

		/* Calls the functions that:
		   a) get the size of the maze and stores it in the dimension variable
		   b) copies the maze into memory */

		dimension = get_maze_dimension(maze_file);
		maze = parse_maze(maze_file, dimension);

	}
	else {
		fprintf(stderr, "Unable to parse maze file: %s\n", MAZE3);
		system("pause");
		return 1;
	}

	/* Traverses maze and generates all solutions */
	generate_all_paths(maze, dimension, start_row, start_col, "");
	/* Calculates and displays required data */

	printf("Total number of solutions: %d\n", paths_found);
	display_shortest_path();
	display_cheapest_path();

	/* Ends main function */
	system("pause");
	return 0;
}

/*
 Acquires and returns the maze size.  Since the maze is always a square, all we
 need to do is find the length of the top row!
 PARM:      maze_file is a pointer to a filestream
 PRE:       maze_file is an initialized pointer to a correctly-formatted maze file
 POST:      maze_file's internal pointer is set to beginning of stream
 RETURN:    length of the first line of text in the maze file EXCLUDING any EOL characters
			('\n' or '\r') and EXCLUDING the string-terminating null ('\0') character.
 */
int get_maze_dimension(FILE* maze_file) {

	int  dimension;
	char line_buffer[BUFFER];

	dimension = strlen(fgets(line_buffer, BUFFER, maze_file));

	/* You don't need to know this.  It 'resets' the file's internal pointer to the
	   beginning of the file. */
	fseek(maze_file, 0, SEEK_SET);

	/* Checks if text file was created in Windows and contains '\r'
	   IF TRUE reduce strlen by 2 in order to omit '\r' and '\n' from each line
	   ELSE    reduce strlen by 1 in order to omit '\n' from each line */
	if (strchr(line_buffer, '\r') != NULL) {
		return dimension - 2;
	}
	else {
		return dimension - 1;
	}
}

/*
 Parses and stores maze as a 2D array of maze_cell.  This requires a few steps:
 1) Allocating memory for a 2D array of maze_cell, e.g., maze_cell[rows][columns]
	a) Dynamically allocates memory for 'dimension' pointers to maze_cell, and assign
	   the memory (case as a double pointer to maze_cell) to maze, which is a
	   double pointer to maze_cell (this makes the maze[rows] headers)
	b) For each row of the maze, dynamically allocate memory for 'dimension' maze_cells
	   and assign it (cast as a pointer to maze_cell) to maze[row]
 2) Copying the file to the allocated space
	a) For each row obtained from the file using fgets and temporarily stored in line_buffer
	   i) For each of the 'dimension' columns in that row
	   ii)Assign the character from the file to the struct, and set the struct to unvisited
 3) Returns the double pointer called maze.
 PARAM:  maze_file pointer to an open filestream
 PARAM:  dimension pointer to an int
 PRE:    maze_file is a pointer to a correctly-formatted maze file
 POST:   dimension contains the correct size of the square maze
 POST:   maze contains a dynamically allocated copy of the maze stored in the maze_file
 RETURN: maze, a maze_cell double pointer, which points to 'dimension' single pointers
		 to maze_cell, each of which points to 'dimension' maze_cell structs.
 */
maze_cell** parse_maze(FILE* maze_file, int dimension)
{
	/* Variables */
	char         line_buffer[BUFFER];
	int          row = 0,
		column = 0;
	maze_cell** maze = NULL;

	/* Allocates memory for correctly-sized maze */

	maze = (maze_cell**)calloc(dimension, sizeof(maze_cell*));


	for (row = 0; row < dimension; ++row) {

		maze[row] = (maze_cell*)calloc(dimension, sizeof(maze_cell));
	}

	/* Copies maze file to memory */
	row = 0;
	while (fgets(line_buffer, BUFFER, maze_file)) {
		for (column = 0; column < dimension; ++column) {

			maze[row][column].character = line_buffer[column];
			maze[row][column].visited = 'N';
		}
		row++;
	}
	return maze;
}

/**
 Generates all paths through a maze recursively.
 PARAM:     pointer to a 2D array of maze_cell
 PARAM:     dimension of the square maze
 PARAM:     starting position row
 PARAM:     starting position column
 PARAM:     pointer to a string of chars which contains the 'current' path
 PRE:       maze contains a representation of the maze
 PRE:       dimension contains the correct dimension of the maze
 PRE:       row contains a valid row coordinate
 PRE:       column contains a valid column coordinate
 PRE:       path contains a sequence of characters (the first time you invoke this
			function, the passed parameter should be an empty string, e.g., "" (not NULL)
 POST:      IF current coordinate is not out of maze bounds &&
			   current coordinate is not a wall
			THEN path contains current coordinate
 POST:      IF current coordinate is at maze finish line (right boundary)
			THEN paths contains the path from start to finish.
 */
void generate_all_paths(maze_cell** maze, int dimension, int row, int column, char* path)
{
	/* Variables */
	int path_length = 0;
	char* new_point = NULL;
	char* new_path = NULL;

	/* Checks for base cases */
	// INSERT CODE HERE: Simply return if we hit one of the base cases (there are more than 1)
	// (remember to delete 1 on the next line, which is here so the incomplete program compiles)
	if (row < 0 || column < 0 || column > dimension - 1 || row > dimension - 1 || maze[row][column].character == '*' || maze[row][column].visited == 'Y') {
		return;
	}

	/* Otherwise deals with the recursive case.  Pushes the current coordinate onto the path
	   and checks to see if the right boundary of the maze has been reached
	   IF   right boundary reached
	   THEN path is added to the list as a successful path and function returns
	   ELSE the current location is marked as used and the search continues
			in each cardinal direction using a recursive call using these steps:
			1. get length of path
			2. allocate space for a larger new path
			3. allocate space for a new point to add to the path
			4. assign the value in the maze cell to the new point
			5. concatenate old path to new path
			6. concatenate new point to new path */
	else {
		path_length = strlen(path);
		new_path = (char*)calloc(path_length + 2, sizeof(char));
		new_point = (char*)calloc(2, sizeof(char));
		new_point[0] = maze[row][column].character;
		if (path_length) {
			new_path = strcat(new_path, path);
		}
		new_path = strcat(new_path, new_point);

		if (column == (dimension - 1)) {
			/* 1. Reallocate memory in global paths array to make room
				  for a new solution string
			   2. Copy the solution path to the location of new string
			   3. Increment paths counter */
			paths = (char**)realloc(paths, (paths_found + 1) * sizeof(char*));
			paths[paths_found] = (char*)calloc(strlen(new_path) + 1, sizeof(char));
			strcpy(paths[paths_found], new_path);
			paths_found++;
			return;
		}
		else {
			/* 1. Mark point as visited
			   2. Recursively search in each direction using the new path
			   3. Mark point as unvisited */

			maze[row][column].visited = 'Y';  //visited

			generate_all_paths(maze, dimension, row - 1, column, new_path); //up 

			generate_all_paths(maze, dimension, row, column - 1, new_path); //left 

			generate_all_paths(maze, dimension, row + 1, column, new_path); //down

			generate_all_paths(maze, dimension, row, column + 1, new_path); //right


			maze[row][column].visited = 'N';  //not visited 
			return;
		}
	}
}

/*
 Calculates the cost for a given path.
 Examples:
 ""    -> 0
 "2"   -> 2
 "871" -> 16
 PARM:   path_string is a pointer to an array of char
 PRE:    path_string is a pointer to a null-terminated array of char (a string)
 RETURN: the 'cost' of the path.
 */
int path_cost(char* path_string)
{
	int index, i;
	int score = 0;
	int length = strlen(path_string);
	char* string = path_string;

	index = 0;
	while (index <= length - 1) {
		i = (string[index]);
		score += i;
		index++;
	}
	return score - 48 * length; // I am quite unaware of the significance of the number 48 in this case, I got some answers without using the (-48 * length) part 
							//then I assumed that somehow the wrong scores that the function spits out must be realted to the length of the path which appears as the cheapest
							//(they were usually the incorrect path ...) so I wrote a few equations by hand and discovered that the X i was looking for is 48 (ARYAN) quite cool and confusing af

}


/*
 Displays the shortest path in the paths global variable, where the shortest path
 has the fewest cells.  In the event of a tie, use the first 'shortest' path found.
 Uses this format:
 "Shortest path: XXXXXXXX"
 POST: prints the shortest path to standard output
 */
void display_shortest_path()
{
	int leng = 0;
	int i;
	int c = 0;
	int min = strlen(paths[0]);
	for (i = 0; i < paths_found; i++) {
		leng = strlen(paths[i]);
		if (leng < min) {
			min = leng;
			c = i;
		}

	}
	printf("Shortest path: %s\n", paths[c]);
}

/*
 Displays the cheapest path in the paths global variable, where the cheapest path
 has the lowest sum value of its cells.  In the event of a tie, use the first
 'cheapest' path found.
 Uses this format:
 "Cheapest path: XXXXXXXX
  Cheapest path costs: 9999"
 POST: prints the cheapest path and its cost to standard output
 */
void display_cheapest_path()
{
	int i, j, len, score;
	int index = 0;
	int score_min = path_cost(paths[index]);

	for (i = 0; i < paths_found; i++) {
		score = path_cost(paths[i]);
		if (score < score_min) {
			score_min = path_cost(paths[i]);
			index = i;
		}
	}

	printf("Cheapest path: %s\n", paths[index]);
	printf("Cost of path: %d\n", score_min);

}

/* End of file */