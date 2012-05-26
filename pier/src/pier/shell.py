'''
Jon Binney
2010.12.18
'''

from IPython.Shell import IPShellEmbed

def make_shell():
    '''
    Create an ipython shell. Once in the shell, the user can
    interactively inspect and modify data.
    '''
    ipshell = IPShellEmbed(argv=[], banner="pier interactive shell")
    return ipshell
