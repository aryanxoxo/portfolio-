/*
 File:              linkedlist.c
 Purpose:           Prototypes for a linked list implementation
 Author:			Aryan Chahardovalee
 Student #s:		55476444 and 99732539
 CS Accounts:		e0e2b and V7k2b
 Date:				October 28th 2019
 */
 
/* Preprocessor directives */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "linkedlist.h"

/******************************************************************
 PLEASE EDIT THIS FILE

 Comments that start with // should be replaced with code
 Comments that are surrounded by * are hints
 ******************************************************************/

/*
 Main function drives the program.  Every C program must have one
 main function.  A project will not compile without one.

 In our program, the main function does nothing.  That's because
 our program doesn't do anything.  We're just implementing a linked
 list and testing it using our unit tests.

 PRE:    NULL (no pre-conditions)
 POST:	 NULL (no side-effects)
 RETURN: IF the program exits correctly
		 THEN 0 ELSE 1
 */
int main ( void )
{
	/* The system command forces the system to pause */
	system(  "pause");
	return 0;
}

/*
 Returns a pointer to a new, empty linked list of struct node.
 PRE:       NULL (no pre-conditions)
 POST:      NULL (no side-effects)
 RETURN:    A pointer to a new, empty linked list of struct node (NULL)
 */
struct node * create_linked_list()
{
	struct node* havapeyma = NULL;
	return havapeyma;
}

/*
 Returns a dynamically allocated struct node that contains the specified
 struct airplane.  The node's next pointer doesn't point to anything
 e.g., it is equal to NULL.
 PARAM:     plane, a struct airplane
 PRE:       NULL (no pre-conditions)
 POST:      NULL (no side-effects)
 RETURN:    A pointer to a dynamically allocated struct node a) that contains
            the specified struct airplane, and b) whose next pointer points to NULL
 */
struct node * create_node(struct airplane plane)
{
	struct node* havapeyma = (struct node*)malloc(sizeof(struct node));
	havapeyma->plane = plane;
	havapeyma->next = NULL;
	return havapeyma; 

}

/*
 Prepends a struct node passed as a parameter to the list passed as a
 parameter, and returns a pointer to the result.
 PARAM:     list is a pointer to a (possibly empty) linked list of struct node
 PARAM:     new_node is a pointer to a struct node
 PRE:       new_mode is not null
 POST:      The specified struct node is added to the beginning of the list
            and its next pointer points to the node that used to be first
 RETURN:    A pointer to a linked list which contains all of the nodes
            of the list passed as a parameter, plus a prepended node
 */
struct node * prepend_node(struct node * list, struct node * new_node)
{
	new_node->next = list;
	return new_node; 
}

/*
 Deletes the first struct node in the specified list, and returns a pointer to
 the shortened list.
 PARAM:     list is a pointer to a (possibly empty) linked list of struct node
 PRE:       NULL
 POST:      The list passed as a parameter has one fewer node, and the dynamically
            allocated memory which contained that removed node has been freed
 RETURN:    IF the list is empty
            THEN NULL
            ELSE a pointer to the shortened list
 */
struct node * delete_node(struct node * list)
{
	struct node* temp;
	if (list != NULL) {
		temp = list->next;
		free(list);
		return temp;
	}
	else {
		return list;
	}

}

/*
 Returns the number of nodes in the specified linked list of struct node.
 PARAM:     list is a pointer to a (possibly empty) linked list of struct node
 PRE:       NULL (no pre-conditions)
 POST:      NULL (no side-effects)
 RETURN:    The length of the specified list, an int
 */
int get_length(struct node * list)
{
	int count = 0;
	struct node* ptr;
	for (ptr = list; ptr != NULL; ptr = ptr->next){
		count++;
	}
	return count;

}

/*
 Deletes an entire list.  This function iterates along a list and deallocates the
 memory containing each struct node.  
 PARAM:     list is a pointer to a (possibly empty) linked list of struct node
 PRE:       NULL (no pre-conditions)
 POST:      The memory containing all of the nodes in the list has been freed
 RETURN:    an empty list (NULL)
 */
struct node * delete_list(struct node * list)
{
	int length = get_length(list);
	int i;
	for (i = 0; i < length; i++) {
		list = delete_node(list);
	}
	return list;
}

/*
 Prints the data stored in a node.  For the struct airplane in the node,
 prints the fields on separate lines.  For each field, prints the field name
 and the field value.  For the pointer, prints "Link = NULL\n" if the pointer points
 to null, else prints "Link points to address xxx\n", where xxx is the pointer address
 in hexademical.
 If node_to_print is NULL, prints "The node is empty\n".
 PARAM:     node_to_print is a pointer to a (possibly null) struct node
 PRE:       NULL (no pre-conditions)
 POST:      Information about node_to_print has been printed to standard output
 RETURN:    NULL
 */
void print_node(struct node * node_to_print)
{
	if (node_to_print == NULL) {
		printf("The node is empty:(\n");
	}
	else {
		printf("INFORMATION OF FLIGHT NUMBER %d TO %s\n", (node_to_print->plane).flight_number, (node_to_print->plane).city_destination);
		printf("Flight number : %d\n", (node_to_print->plane).flight_number);
		printf("Flight Origin : %s\n", (node_to_print->plane).city_origin);
		printf("Flight Destination : %s\n", (node_to_print->plane).city_destination);
		printf("Flight Priority : %d\n", (node_to_print->plane).priority);
		printf("Maximum Speed : %d kph\n", (node_to_print->plane).maximum_speed_kph);
		printf("Cruising Altitude : %d m\n", (node_to_print->plane).cruising_altitude);
		printf("Flight Capacity : %d \n\n", (node_to_print->plane).capacity);
		if (node_to_print->next == NULL) {
			printf("Link = NULL\n\n");
		} else {
			printf("Link points to address %X \n\n", node_to_print->next);
		}
	}
}

/*
 Prints the data stored in all nodes in the specified list to print.
 For each node, prints the data inside the node the same way that it
 is printed by print_node.  If the list is empty, a suitable message
 is printed to standard output.
 PARAM:     node_to_print is a pointer to a (possibly empty) linked list of
            struct node
 PRE:       NULL (no pre-conditions)
 POST:      Information about list_to_print has been printed to standard output
 RETURN:    NULL
 */
void print_list(struct node * list_to_print)
{
	int length = get_length(list_to_print);
	int i;
	struct node* print = list_to_print;

	if (print == NULL) {
		printf("There are currently no nodes in the list to be printed!\n");
	}
	else {
		for (i = 0; i < length; i++) {
			print_node(print);
			print = print->next;
		}
	}
}


/*
 Reverses a list. 
 PARAM:     list is a pointer to a (possibly empty) linked list of struct node
 PRE:       NULL (no pre-conditions)
 POST:      The order of the nodes in the list passed as a parameter has been
            reversed
 RETURN:    a list of struct node that is the reverse of the list passed as a
            parameter
 */
struct node * reverse(struct noode * list)
{
	int i = 0;
	int length = get_length(list);
	for (i = 0; i < (length / 2); i++) {
		struct node* begining = retrieve_nth(list, i+1);
		struct node* end = retrieve_nth(list, length - i);
		struct airplane temp;
		temp = begining->plane;
		begining->plane = end->plane; 
		end->plane = temp; 
	}
	return list; 

}

/*
 Removes every node from the list which contains an airplane destined for
 the city name passed in the second parameter.
 PARAM:     list is a pointer to a (possibly empty) linked list of struct node
 PARAM:     destination_city is a pointer to a null-terminated array of char
 PRE:       NULL (no pre-conditions)
 POST:      Any struct node in the list which contains an airplane struct
            destined for the destination_city is removed from the list, and
            the memory deallocated
 RETURN:    a list of struct node that does not contain any struct node that
            has an airplane destined for the destination_city
 */
struct node * remove_from_list(struct node * list, char * destination_city)
{

	struct node* ptr, *previous,*fnode;
	struct node* del = NULL; 
	int length = get_length(list);
	
	if (length == 1 && ( (list->plane).city_destination == destination_city) ){
		return delete_node(list);
	}
	else {
		if (list == NULL) {
			return list;
		}
		else {
			if ((list->plane).city_destination == destination_city) {
				fnode = list;
				list = list->next;
				free(fnode);
			}
		}

		ptr = list;
		while (ptr != NULL) {
			previous = ptr;
			ptr = ptr->next;
			struct airplane havapeyma = ptr->plane;
			if (havapeyma.city_destination == destination_city) {
				previous->next = ptr->next;
				del = ptr;
				ptr = ptr->next;
				free(del);
			}


		}
		
	}
	return list;
}

/*
 Returns a reference to the nth node (but does not remove it ) in the
 specified list.  If the list is too short, returns NULL.
 PARAM:     list is a pointer to a (possibly empty) linked list of struct node
 PARAM:     ordinality is an integer
 PRE:       ordinality > 0
 POST:      NULL (no side-effects)
 RETURN:    IF ordinality <= length of list
            THEN a pointer to the nth node
            ELSE NULL
 */
struct node * retrieve_nth(struct node * list, int ordinality)
{
	struct  node* result = NULL;
	int i;
	int length = get_length(list);
	if (ordinality <= length) {
		for (i = 0; i < ordinality; i++) {
			result = list;
			list = list->next; 
		}
	}
	return result;
}

/*
 Inserts the specified node into the specified list of nodes at the specified
 ordinality.  For example, if ordinality = 1, this is a simple prepend_node
 operation.  If ordinality = 3, then when this function is finished, the third
 node in the list will be the node_to_insert.  If the ordinality = the length
 of the list + 1, then the node_to_insert is appended to the end of the list.
 If the ordinality > 1 + length of the list, the function returns a pointer
 to the unchanged list.
 PARAM:     list is a pointer to a (possibly empty) linked list of struct node
 PARAM:     ordinality is an integer
 PRE:       ordinality > 0
 PRE:       node_to_insert is NEVER a null (it is always a correct node pointer)
 POST:      NULL (no side-effects)
 RETURN:    IF ordinality <= length of list + 1
            THEN a pointer to the list which contains the node_to_insert in the
			correct location
            ELSE a pointer to the unchanged list
 */
struct node * insert_nth(struct node * list, struct node * node_to_insert, int ordinality)
{
	int length = get_length(list);
	int i;

	struct node* ptr, *result;

	if (ordinality == 1) {

		result = prepend_node(list, node_to_insert);
		return result;

	} else if (ordinality == length + 1) {
		ptr = list;
		for (i = 1; i < length ; i++) {
			ptr = ptr->next;
		}
		ptr->next = node_to_insert;
		node_to_insert->next = NULL;
		return list; 

	} else if (ordinality > length + 1) {

		return list;

	} else {
		ptr = retrieve_nth(list, ordinality-1);
		node_to_insert->next = ptr->next;
		ptr->next = node_to_insert; 
		return list;
	}
		
}
