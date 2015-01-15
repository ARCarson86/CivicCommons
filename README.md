# Welcome to The Civic Commons ![Build Status](http://ci.l7lab.com/buildStatus/icon?job=Civic%20Commons)

[www.theciviccommons.com](http://www.theciviccommons.com)

The Civic Commons is a new way to bring communities together with conversation and emerging technology. We’re focused on building conversations and connections that have the power to become informed, productive collective civic action.

A commons is a shared public space devoted to the public good. And that’s what The Civic Commons is—a space we come to so we can learn more about our shared interest and then act on it together. We’ll build it with our contributions, conversations and actions.

Even while this is important, heady stuff, we want to make your civic involvement easy and fun, something you can do after you put the kids to bed, something you might actually want to do, as much as, say, you want to fire up the DVR or head over to Facebook. Think of The Civic Commons as social media for civic good.

How The Civic Commons works
===========================
If you prefer video to text, be sure to check out our how-to video. If you’re not a check-out-the-video kind of citizen, you’ll just jump in and likely meet some of the passionate team whose work is grounded in our founding principles. A number of community partners share our commitment to those principles.


Funding Support
---------------
The John S. and James L. Knight Foundation


Organizational Support
----------------------
The Fund For Our Economic Future

Contributing
============
    * Fork
    * Make Changes (Adding and updating tests as needed)
    * Submit pull request
    * Profit

Runtime Dependencies
--------------------
    * Ruby 1.9.*
    * mysql
    * libiconv
    * imagemagick

Test Dependencies
-----------------
    * qt4.7+

Installation
------------
From your command line:

    git pull git@github.com/CivicCommons/CivicCommons
    bundle install
    bundle exec rake db:setup

Running the App
---------------
From your command line:

    bundle exec rake server:start

Deploying the app
-----------------
    ey recipes upload -e <environment you want to deploy to>
    ey rebuild -e <environment you want to deploy to>

Note: You will be asked to log in with the engine yard credentials. 

    If you don't have access, talk to Winston.

Copyright
---------
Copyright (c) The Civic Commons -- released under the MIT license.

License
-------
[http://www.opensource.org/licenses/mit-license.php](http://www.opensource.org/licenses/mit-license.php)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
