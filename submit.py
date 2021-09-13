import os, math 
import argparse
import shutil
import htcondor
import subprocess
pjoin = os.path.join

def chunkify(items, nchunk):
    '''Split list of items into nchunk ~equal sized chunks'''
    chunks = [[] for _ in range(nchunk)]
    for i in range(len(items)):
        chunks[i % nchunk].append(items[i])
    return chunks

def submit_dict(tag,ichunk,input_files,arguments,request_cpus=1):
    """
    submission_settings = {
        "should_transfer_files" : "YES",
        "transfer_input_files" : ", ".join(input_files),
        "executable": os.path.abspath("./miniaod_workflow_sonic.sh"),
        "arguments": " ".join([str(x) for x in arguments]),
        "Output" : "out_%s_%i.txt"% ( tag, ichunk ),
        "Error" : "err_%s_%i.txt" % ( tag, ichunk ),
        "log" : "log_%s_%i.txt"   % ( tag, ichunk ),
        "WhenToTransferOutput" : "ON_EXIT_OR_EVICT",
        "universe" : "vanilla",
        "request_cpus" : request_cpus,
        "request_memory" : 1250*request_cpus,
        "+JobPrio" : 20000,
        "+DESIRED_Sites" : "T3_US_HEPCloud",
        "+DESIRED_Resources" : "T3_US_HEPCloud_Google" ,
        "+REQUIRED_OS" : "rhel7",
        "+WantIOProxy" : "true",
    }
    """
    submission_settings = [
        'universe = vanilla',
        'Executable = {}'.format("./miniaod_workflow_sonic.sh"),
        'should_transfer_files = YES',
        'when_to_transfer_output = ON_EXIT',
        'transfer_input_files = {}'.format(' '.join(input_files)),
        'arguments = {}'.format(' '.join([str(x) for x in arguments])),
        'Output = {}'.format("out_$(Cluster)_$(Process)_{}_{}.txt".format(str(tag), str(ichunk))),
        'Error = {}'.format("err_$(Cluster)_$(Process)_{}_{}.txt".format(str(tag), str(ichunk))),
        'Log = {}'.format("log_$(Cluster)_$(Process)_{}_{}.txt".format(str(tag), str(ichunk))),
        'x509userproxy = /home/wmccorma/x509up',
        '+REQUIRED_OS = "rhel7"',
        '+JobPrio = 200000',
        'RequestDisk = 70',
        'RequestCpus = {}'.format(str(request_cpus)),
        'RequestMemory = {}'.format(str(1250*request_cpus)),
        '+Require_CVMFS = True',
        '+DESIRED_Sites = "T3_US_HEPCloud"',
        '+DESIRED_Resources = "T3_US_HEPCloud_Google"',
        '+WantIOProxy = true'
    ]

    return submission_settings

def setup_jobs(FLAGS):

    wdir = os.path.abspath("./wdir/%s/"%FLAGS.output_directory)
    try:
        os.makedirs(wdir)
    except:
        print("Directory already exists...")

    try: 
        CMSSW_VERSION = os.environ["CMSSW_VERSION"]
    except:
        raise ValueError("Work from a cms release")


    owd = os.getcwd()
    os.chdir(pjoin(os.environ["CMSSW_BASE"],".."))
    print("Tarring cmssw at", os.getcwd())
    os.system('echo tar -zvcf %s_%s.tgz %s --exclude="*.root" --exclude="*.pdf" --exclude="*.pyc" --exclude=tmp --exclude="*.tgz" --exclude-vcs --exclude-caches-all --exclude="*err*" --exclude=*out_* --exclude=*jdl --exclude=*sub'%(CMSSW_VERSION,FLAGS.output_directory,CMSSW_VERSION))
    os.system('tar -zvcf %s_%s.tgz %s --exclude="*.root" --exclude="*.pdf" --exclude="*.pyc" --exclude=tmp --exclude="*.tgz" --exclude-vcs --exclude-caches-all --exclude="*err*" --exclude=*out_* --exclude=*jdl --exclude=*sub'%(CMSSW_VERSION,FLAGS.output_directory,CMSSW_VERSION))

    print("tar complete")
    os.chdir(owd)
    gp_original = pjoin(os.environ['CMSSW_BASE'],'..','%s_%s.tgz'%(CMSSW_VERSION,FLAGS.output_directory)) 
    gp = pjoin(wdir, os.path.basename(gp_original))
    shutil.copyfile(gp_original, gp)
    files = []
   
    if FLAGS.throughput_test:
        files = ["/store/relval/CMSSW_10_6_4/RelValProdTTbar_13_pmx25ns/AODSIM/PUpmx25ns_106X_upgrade2018_realistic_v9-v1/10000/4440FA53-897B-9A4B-AD76-D1337B591A2F.root"] 
        njobs = range(FLAGS.number_of_jobs)
       

    elif FLAGS.fileset:
        file_of_files = open(FLAGS.fileset,"r")
        files = [line.strip() for line in file_of_files.readlines()]
        print(len(files))
        print(FLAGS.files_per_job)
        njobs = chunkify(files, int(math.ceil(len(files) / FLAGS.files_per_job)))


    for ichunk, chunk in enumerate(njobs):
        input_files = [gp]
        arguments = [
            int(FLAGS.throughput_test),
            CMSSW_VERSION,
            FLAGS.output_directory,
            FLAGS.threads,
        ]
        if FLAGS.throughput_test: arguments += files
        elif FLAGS.fileset: arguments += chunk
        
        submission_settings = submit_dict(FLAGS.output_directory,ichunk,input_files,arguments,request_cpus=FLAGS.threads)   

        jobfile = pjoin(wdir, "skim_%i.sub"%ichunk)
        #sub = htcondor.Submit(submission_settings)

        with open(jobfile,"w") as f:
            for l in submission_settings:
                f.write(l+'\n')
            #f.write(str(sub))
            f.write("\nQueue 1\n")
        
        print('about to condor_submit')
        print(jobfile)
        os.system('echo "TEST"')

        print('what is dryrun ')
        print(FLAGS.dry_run)
        if not FLAGS.dry_run:
            os.system('condor_submit %s'%jobfile)
            #os.system('echo "TESTFLAG"')
            #os.system('condor_submit /storage/local/data1/wmccorma/test_workflow_MAIN/CMSSW_12_0_0_pre5/src/wdir/test_ttbar/skim_0.jdl')
            #subprocess.run(["ls"])


def parse_cmd():
    parser = argparse.ArgumentParser()

    parser.add_argument('-tptest', '--throughput-test', action="store_true",
                        help='Indicates flavour of test is throughput.')
    parser.add_argument('-d', '--dry-run', action="store_true",
                        help='Do not submit the jobs to condor.')
    parser.add_argument('-nj', '--number-of-jobs', type=int, default=None,
                        help='Indicates number of jobs to submit.')
    parser.add_argument('-f', '--fileset', type=str,default=None,
                        help='File containing dataset for processing.')
    parser.add_argument('-nf', '--files-per-job', type=int, default=None,
                        help='Number of files per job.')
    parser.add_argument('-t', '--threads', type=int, default=4,
                        help='Number of threads executed per job.')
    parser.add_argument('-o', '--output-directory', type=str, required=True,
                        help="Directory to put condor logs.")


    return parser.parse_args()

if __name__ == "__main__":
    FLAGS = parse_cmd()
 
    if not ((FLAGS.throughput_test and not FLAGS.fileset) or (not FLAGS.throughput_test and FLAGS.fileset)):
        raise ValueError("Must give either a fileset to process or indicate a throughput test")

    if FLAGS.fileset and not FLAGS.files_per_job:
        raise ValueError("Number of files per job must be provided.")
    if FLAGS.throughput_test and not FLAGS.number_of_jobs:
        raise ValueError("Number of jobs must be provided.")

    setup_jobs(FLAGS)
