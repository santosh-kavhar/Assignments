import subprocess

ifconfig_output = ""

def get_processes_output():
	# -b for batch mode to display all the processes
	# -n for number of iterations, here only 1
	processes = [ ['ifconfig'], ['df', '-h'], ['iostat'], ['top','-b', '-n', '1'] ] # ['ls', 'k']

	for process in processes:
		result = None
		err = ""
		output = ""
		try:
			result = subprocess.run(process, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
		except:
			print("Please check your command!!\t", process)
			exit(-1)
		if result.stdout != None:
			output = result.stdout.decode('utf-8')
			if process == ['ifconfig']:
				global ifconfig_output 
				ifconfig_output = output
			print("\nStdOut:\n", output)
		if result.stderr != None:
			err = result.stderr.decode('utf-8')
			print("\nErr:\n", err)

def macs_to_file():
	# Open mac.txt for writing MACs
	try:
		mac_file = open("mac.txt", "w")
		for line in ifconfig_output.splitlines():
			if line.strip().startswith("ether"):
				mac_address = line.strip().split(" ")[1]
				mac_file.write(mac_address + "\n")
				#print(mac_address)
		mac_file.close()

	except:
		print("Couldn't create mac.txt file, try using sudo")
		exit(-1)


	
def print_errors_to_file():
	#files to read
	files_to_check = ['dmesg', 'auth.log', 'boot.log', 'kern.log']
	directory_to_check = '/var/log/'

	try:
		err_file = open("err.txt", "w")
		for file_name in files_to_check :
			file = open(directory_to_check + file_name, 'r')
			lines = file.readlines()
			count = 0
			for line in lines:
				count +=1
				if "error" in line.lower() or "fail" in line.lower():
					#print("File: {} \tLine: {} : {}".format(file_name, count, line.strip()))
					err_file.write("File: {} \tLine: {} : {}\n".format(file_name, count, line.strip()))
	except:
		print("Couldn't create err.txt file, try using sudo")
		exit(-1)


get_processes_output()

macs_to_file()

print_errors_to_file()
