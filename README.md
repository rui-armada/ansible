Ansible
## Usage instructions

#### Setting up a virtual machine to test on

You have a few options to test the playbooks. You can setup a virtual machine using something like virtualbox or you can use vagrant. Ansible also supports popular cloud services but you're on your own if you want to deploy to them.

For the sake of simplicity I'm not going to walk you through on how to use vagrant. There's plenty of documentation on how to do this available on Google. From this point on I'm going to assume you have access to at least 1 IP address that you can ssh into which is where you will be testing the playbooks. You should also use ubuntu server 12.04 LTS.

#### File structure break down

Each folder inside of this repo will contain an inventory along with a playbook to perform some type of server orchestration. Each folder also has its own readme for specific documentation.

Each folder in this repo will be laid out in a similar way. Here are the rules and expectations:

- The playbook's name is the folder name for organizational purposes.
  - `files`
  - `handler`
  - `inventories` will exist inside of the playbook folder.
      - `live` will exist inside of the environment folder.
          - `hosts` will exist inside of the production folder.
          - `group_vars` will exist inside of the production folder.
      - `staging` will exist inside of the environment folder.
          - `hosts` will exist inside of the development folder.
          - `group_vars` will exist inside of the development folder.
  - `playbooks`
  - `roles`
  - `ansible.cfg`
  - `hosts.yml`
  - `README.md` 

Normally you would not want your `inventory` folder inside of a playbook. I am only doing this to keep things contained for the repo's sake if you decide to clone it. On your workstation/devbox you should have an `inventory` folder somewhere that is outside of all of your playbooks.

The basic idea is that your configuration is isolated from the implementation details of the playbook. This allows you to share your playbooks or push them somewhere without having to worry about leaking sensitive information.

## General information and terminology

#### The `hosts` file

You will need to put the IP address of each server in the `hosts` file. If you only plan to spin up 1 server then you can just use the same IP address for each group. Setting up a dynamic hosts file is out of scope and is well documented elsewhere.

#### The `site.yml` file

This is the playbook. It consists of 1 or more plays. A play is a series of tasks associated to a group of servers. The tasks themselves could be inside of roles. It is fairly common to see and say "A play has many roles and each role has many tasks".

#### The `inventory` directory

This is what I like to label as configuration data. Sensitive information may or may not be included here and may or may not be checked into version control. It's up to you. It is very beneficial to be able to use the same playbook for many different sites. Having your inventory isolated away from the playbook allows you to do this.

Imagine having 10 rails apps. You wouldn't need 10 playbooks. You only need 1 playbook and a way to customize the configuration data like which IPs it should use, user credentials, ssl certificates and all of that fun stuff.

#### Securing passwords and other sensitive files

Some of the playbooks have roles that may contain sensitive information such as a postgres password, an ssl certificate or a private ssh key. You may want to keep them out of your inventory in case you're checking it into version control.

There are multiple ways to solve this issue but the easiest way I've found was to keep the secrets in some folder outside of version control and outside of your inventory folder. You can choose to encrypt these files locally or not, this is up to you and out of scope.

In certain playbooks you may see variables named `secrets_load_path`. This is the full path of where your secrets should live on your local workstation. You may also see variables such as `secrets_postgres_password: "{{ lookup('password', secrets_load_path + 'database_password') }}"`.

That expects there to be a file called `database_password` which contains 1 line only. This line would be the plain text password. The `lookup` module takes a file from your local workstation and places the contents of it into a variable. It's great for passwords.

For files like ssl certificates there is another module called `copy` which will copy a file locally onto a remote server but you don't have to worry much about that. For example with the `nginx` role it has an `nginx_ssl_local_path` variable that expects you to point to a directory that contains your secrets just like the `secrets_load_path`. In fact you can just set your secret path up once and then use that variable.

For example: `nginx_ssl_local_path: "{{ secrets_load_path }}"`.

You will see this pattern in most playbooks that require sensitive information.

#### Dependencies

Ansible allows you to publish roles on a community site called the [ansible galaxy](https://galaxy.ansible.com/). When you installed ansible it came with a program called `ansible-galaxy`. You can use this tool to download roles from the galaxy by doing `ansible-galaxy install roleowner.rolename`.

Dependencies for each playbook will be expected to be downloaded and will be listed at the top of each readme.

It will download the role onto your workstation in `/etc/ansible/roles` or wherever you decided to install ansible to. Once the role is on your workstation then you can just reference it like `nickjj.nginx` in your playbook, you will see this in action in most playbooks.

#### Skill level

I'm going to assume you know the basics from here on out otherwise there's just going to be too much documentation to write for each playbook. Most of the documentation will be covered by comments in each playbook.

I will also try to post short video tutorials for each one showing you how to set them up from start to finish but don't expect the videos to be released at the same time of the playbook. They will be created whenever I can find the time.

## Playbooks

- [rails-basic](https://github.com/nickjj/ansible-playbooks/tree/master/rails-basic)
  - Setup a full basic rails stack.

- [devbox](https://github.com/nickjj/ansible-playbooks/tree/master/devbox)
  - Setup a local development box geared towards ruby/node development.

## Command Examples
The following command will apply all changes performed in network to the playbook `balancer.yml` on production inventory but limited by the machine `srvbalancer01` 
`ansible-playbook -i inventory/production playbooks/balancer.yml --limit "srvbalancer01" --tags "network"`
