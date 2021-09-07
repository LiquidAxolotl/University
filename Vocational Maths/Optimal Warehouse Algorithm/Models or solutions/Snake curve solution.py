from turtle import *
import math

#take inputs for the warehouse's dimensions and the pallet's dimensions and the minimum width for the forklift to operate
WAREHOUSEWIDTH = float(input('Warehouse width: '))
WAREHOUSELENGTH = float(input('Warehouse length: '))
PALLETWIDTH = float(input('Pallet Width: '))
PALLETLENGTH = float(input('Pallet Height: '))
FORKLIFTSPACE = float(input('minimum operating space for the forklift: '))
DOORPOS = int(input('location of the door: ')) #allgin the door with the grid
if DOORPOS < 0 or DOORPOS > WAREHOUSELENGTH:
        raise Exception('Invalid door location')

#split the warehouse into a grid of pallets
width = WAREHOUSEWIDTH/PALLETWIDTH
length = WAREHOUSELENGTH/PALLETLENGTH

#initialise the variable to store the amount of space wasted
wasted_space = 0

#generate a grid for a graphical representation
setworldcoordinates(-1, -1, width+1, length+1)
bgcolor('black')
grid = []
tracer(False, 0)
for x in range(int(width)):
    column = []
    for y in range(int(length)):
        t = Turtle();t.pu();t.goto(x*(WAREHOUSEWIDTH/WAREHOUSELENGTH),y);t.shapesize(3/(PALLETWIDTH/PALLETLENGTH)*(3/(length)**(2/3)), 3*(3/(width)**(2/3)));t.shape('square');t.color('white')  #graphical code to draw the warehouse
        t.speed(0)
        column.append(t)
    grid.append(column)


#calculate the wasted space from chopping the warehouse into a grid
wasted_space += length*width-int(length)*int(width) #see diagram 1

#begin calculating where the snake curve goes
coordinates = [(0, DOORPOS)] #store the inital coordinates
next_coordinate = coordinates[0]
direction = 1 #keeps track of which way the "snake" is moving#reorientate the problem so we know which way to move by checking if the door is on the left or right wall
while next_coordinate[1] < int(length)-1: #start by moving from the door to the top of the screen
        next_coordinate = (next_coordinate[0], next_coordinate[1]+1)
        coordinates.append(next_coordinate)
while next_coordinate[1] > 0: #gradually snake back down to the bottom of the grid
        if (next_coordinate[0] == int(width)-2 and direction == 1) or (next_coordinate[0] == 3 and next_coordinate[1] >= DOORPOS and direction == -1) or (next_coordinate[0] == 1 and next_coordinate[1] < DOORPOS and direction == -1):
            for i in range(min(3, next_coordinate[1]-1)): #this min stops the snake from going off the bottom of the grid
                next_coordinate = (next_coordinate[0], next_coordinate[1]-1) #move the snake down by one
                coordinates.append(next_coordinate)
            direction *= -1 #make the snake go in the other direction
        next_coordinate = (next_coordinate[0]+direction, next_coordinate[1]) #move the snake across the grid
        if next_coordinate in coordinates: #if the snake doubles back on itself, abort the process
            break
        coordinates.append(next_coordinate)
coordinates.append((next_coordinate[0]-2*direction, next_coordinate[1])) #move the snake one further along so it hits the wall for slightly increased efficency
number_accessable = 0

for coord in coordinates: #find and colour every single pallete accessable by the snake path
    for x in range(int(width)):
        for y in range(int(length)):
                if (x in (coord[0]-1, coord[0]+1) and y == coord[1]) or (y in (coord[1]-1, coord[1]+1) and x == coord[0]):
                    grid[x][y].color('green')

for coord in coordinates: #draw the path on the grid
    if coord[0] >= 0 and coord[1] >= 0: #just in case the algorhtmn breaks????!!!!!!!
        grid[coord[0]][coord[1]].color('yellow')

#colour the door brown
grid[0][DOORPOS].color('brown')

for x in range(int(width)):
    for y in range(int(length)):
        if grid[x][y].color() == ('green', 'green'): #count every green tile on the grid
            number_accessable += 1

tracer(True, 0)
#calculate the number of pallet spaces unaccessable by the path
wasted_pallets = int(width)*int(length)-number_accessable

#compute the area of these wasted pallets and add it to the already existing wasted area
wasted_space += PALLETWIDTH*PALLETLENGTH*wasted_pallets
efficency = wasted_space/(length*width)
print(wasted_space, 'amount of space wasted')
print(1-efficency, 'the efficency')
print(number_accessable, 'the actual number of pallets that can be stored')




    

