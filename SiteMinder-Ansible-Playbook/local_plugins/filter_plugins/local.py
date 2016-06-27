# (c) 2014, Nicolas MASSE
#

import re
from ansible import errors

def regex_replace(s, find, replace):
    return re.sub(find, replace, s)

class FilterModule(object):
    ''' Custom Filters '''

    def filters(self):
        return {
            # regex
            'regex_replace': regex_replace,
        }

