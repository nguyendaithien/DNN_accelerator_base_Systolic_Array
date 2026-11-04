#!/usr/local/bin/python3.7
import yaml
import sys
import os
import subprocess
import datetime


def parse_yaml_to_verilog(yaml_file, verilog_file):
    # Read the YAML content from the input file
    with open(yaml_file, 'r') as f:
        data = yaml.safe_load(f)

    # Read the existing Verilog content from the output file
    with open(verilog_file, 'r') as f:
        verilog_content = f.readlines()

    # Collect mpath information
    mpath_list = [instance['mpath'] for instance in data['instance']]
    directories = set(os.path.dirname(mpath) for mpath in mpath_list)

    # Get timestamp
    current_date = datetime.datetime.now().strftime("%d.%m.%Y")

    # Open the output Verilog file for writing
    with open(verilog_file, 'w') as f:
        inside_qonnex_block = False
        for line in verilog_content:
            if '// Qonnex' in line:
                inside_qonnex_block = True
                f.write(line)  # Preserve the // Qonnex line
                f.write("\t/*AUTOWIRE*/\n");
                f.write("\t/*AUTOREG*/\n");
                for instance in data['instance']:
                    f.write("  /*\n")
                    f.write("   {} AUTO_TEMPLATE (\n".format(instance['mname']))
                    if instance['ports']:
                        for port in instance['ports']:
                            if isinstance(port, dict):
                                for key, value in port.items():
                                    f.write("   .{}({}),\n".format(key, value))
                    f.write("   );\n")
                    f.write("   */\n")
                    f.write("  {} #(/*AUTOINSTPARAM*/)\n  {}(/*AUTOINST*/);\n".format(instance['mname'], instance['name']))
                    #f.write("  {} {}(/*AUTOINST*/);\n".format(instance['mname'], instance['name']))
                    f.write("\n")
            elif 'endmodule' in line:
                f.write(line)
                break  # Stop writing after endmodule
            elif 'EndQonnex' in line:
                inside_qonnex_block = False
                f.write(line)
            elif not inside_qonnex_block:
                f.write(line)

        # Add Local Variables section
        f.write("\n")
        f.write("// Local Variables:\n")
        if len(directories) == 1:
            directory = directories.pop()
            f.write("// verilog-library-directories: (\"{}\")\n".format(directory))
            mpath_list = [mpath for mpath in mpath_list if os.path.dirname(mpath) != directory]
        if mpath_list:
            f.write("// verilog-library-files:({})\n".format(", ".join(['"{}"'.format(mpath) for mpath in mpath_list])))

        f.write("// verilog-auto-inst-param-value:t\n")


        if 'options' in data:
            for option in data['options']:
                for key, value in option.items():
                    if key == "verilog-auto-wire-type":
                        f.write("// {}: \"{}\" \n".format(key, value))
                    else:
                        f.write("// {}:{} \n".format(key, value))

        f.write("// End:\n")
        f.close()

        # Call the Emacs batch
        subprocess.run([
        	'emacs', '--batch', verilog_file,
        	'-l', '/projects/ppm/digital_ppm/work_libs/vd101024/cds/dig_work/ddv_az/script/lisp/verilog-mode.el',
        	'--eval', '(require \'verilog-mode)',
        	'-f', 'verilog-auto',
        	'-f', 'mark-whole-buffer',
        	'-f', 'untabify',
        	'-f', 'save-buffer'
        ])

        # Update timestamp
        sed_command = f"sed -i 's|// Last modified : .*|// Last modified : {current_date}|' {verilog_file}"
        subprocess.run(sed_command, shell=True, check=True)

        # Update user
        user = os.getenv('USER')
        sed_command = f"sed -i 's|// Author        : .*|// Author        : {user}|' {verilog_file}"
        subprocess.run(sed_command, shell=True, check=True)

        # Remove empty AUTOINSTPARAM
        sed_command = f"sed -i 's/#(\/\*AUTOINSTPARAM\*\/)//g' {verilog_file}"
        subprocess.run(sed_command, shell=True, check=True)

        # Make ))$ to )\n)$
        sed_command = rf"sed -i 's/))$/)\n  )/g' {verilog_file}"
        subprocess.run(sed_command, shell=True, check=True)

        sed_command = rf"sed -i '/AUTOINSTPARAM/,/AUTOINST/ {{ /^[[:space:]]*\.\([A-Za-z_]*\)[[:space:]]*(\1)/d }}' {verilog_file}"
        subprocess.run(sed_command, shell=True, check=True)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py <input_yaml_file> <output_verilog_file>")
        sys.exit(1)

    input_yaml_file = sys.argv[1]
    output_verilog_file = sys.argv[2]

    parse_yaml_to_verilog(input_yaml_file, output_verilog_file)
