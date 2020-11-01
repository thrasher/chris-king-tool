#!/usr/bin/python
# a reference to openscad must exist
# sudo ln -sf /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD /usr/local/bin/openscad

import subprocess
import math
import time

# render the stl
def render():
	# render each part in a thread, so it all goes faster
	print 'Starting render'
	start = time.time()

	scad = []
	scad.append(subprocess.Popen(['openscad','-D','PART="front_wrench"','parts.scad','-o','chrisking_front_wrench.stl']))
	scad.append(subprocess.Popen(['openscad','-D','PART="front_socket"','parts.scad','-o','chrisking_front_socket.stl']))

	# wait for all threads to finish, so we know we're done
	for p in scad:
		p.wait()

	elapsed = round(time.time() - start, 1)
	print 'Rendering done in', elapsed, 'seconds!'

def main():
	render()

main()