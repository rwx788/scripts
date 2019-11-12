import requests
import sys
import datetime
import plotly.graph_objs as go

from optparse import OptionParser


def get_sprint_date(sprint_number = None):
    # Init with first sprint due date
    due_date = datetime.datetime(2019, 8, 27, 23, 59, 59, 999999)
    start_date = due_date
    sprint_count = 51
    while sprint_count <= sprint_number:
            start_date = due_date + datetime.timedelta(minutes=1)
            due_date += datetime.timedelta(days=14)
            sprint_count += 1

    return {'start_date': start_date, 'due_date': due_date}

def generate_urls_list(init_sprint_number, nr):
    start_sprint = int(init_sprint_number)
    end_sprint = start_sprint + nr
    for sprint in range(start_sprint, end_sprint):
        sprint_info = get_sprint_date(sprint)

        dt_format = '%Y-%m-%d'
        str_start_date = sprint_info['start_date'].strftime(dt_format)
        str_due_date = sprint_info['due_date'].strftime(dt_format)

        # form redmine url
        filter_url = 'https://progress.opensuse.org/issues?utf8=✓&set_filter=1&f[]=subject&op[subject]=~&v[subject][]=[y]&f[]=due_date&op[due_date]=><&v[due_date][]=%s&v[due_date][]=%s&f[]=&c[]=project&c[]=subject&c[]=status&c[]=assigned_to&c[]=fixed_version&c[]=relations&c[]=priority&c[]=updated_on&c[]=category&c[]=due_date&c[]=start_date&c[]=estimated_hours&group_by=status'
        filter_url = filter_url %(str_start_date, str_due_date)
        # form shorten url
        wishId = 'qsf_y_sprint_%s' %(sprint)

        r = requests.post('http://s.qa.suse.de/', data={'url': filter_url, 'wishId': wishId})

        if r.status_code != requests.codes.ok:
            sys.exit("Error: non OK code returned for request:\n%s\n%s" %(r.status_code, r.reason) );

        # Print returned url with formed string for pasting
        print(" * sprint%s: [y_team](%s)" %(sprint, r.text) )

parser = OptionParser()
parser.add_option("-s", "--sprint", dest="sprint",
                  help="SPRINT number for which url will be generated", metavar="SPRINT")
parser.add_option("-n", "--number", dest="nr", default=1,
                  help="Amount of sprint to generate urls for", metavar="SPRINT")

(options, args) = parser.parse_args()

if options.sprint == None:
    sys.exit("Error: No sprint number provided")

generate_urls_list(options.sprint, int(options.nr))
