
PS C:\Users\burce> wget "http://challenge.scy-phy.net:8080/E1/bbc/generate.py"


StatusCode        : 200
StatusDescription : OK
Content           : {102, 114, 111, 109...}
RawContent        : HTTP/1.1 200 OK
                    Accept-Ranges: bytes
                    Content-Length: 1549
                    Content-Type: application/octet-stream
                    Date: Mon, 10 Nov 2025 14:14:38 GMT
                    Server: lighttpd/1.4.69

                    from Crypto.Util.number import *

                    N...
Headers           : {[Accept-Ranges, bytes], [Content-Length, 1549], [Content-Type, application/octet-stream], [Date, Mon, 10 Nov 2025 14:14:38 GMT]...}
RawContentLength  : 1549



PS C:\Users\burce> wget "http://challenge.scy-phy.net:8080/E1/bbc/intercepted-messages"


StatusCode        : 200
StatusDescription : OK
Content           : {78, 49, 32, 61...}
RawContent        : HTTP/1.1 200 OK
                    Accept-Ranges: bytes
                    Content-Length: 3805
                    Content-Type: application/octet-stream
                    Date: Mon, 10 Nov 2025 14:14:38 GMT
                    Server: lighttpd/1.4.69

                    N1 = 157268289006994793576640470381...
Headers           : {[Accept-Ranges, bytes], [Content-Length, 3805], [Content-Type, application/octet-stream], [Date, Mon, 10 Nov 2025 14:14:38 GMT]...}
RawContentLength  : 3805



PS C:\Users\burce> Get-Content .\generate.py -TotalCount 200
Get-Content : Cannot find path 'C:\Users\burce\generate.py' because it does not exist.
At line:1 char:1
+ Get-Content .\generate.py -TotalCount 200
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (C:\Users\burce\generate.py:String) [Get-Content], ItemNotFoundException
    + FullyQualifiedErrorId : PathNotFound,Microsoft.PowerShell.Commands.GetContentCommand

PS C:\Users\burce> sed -n '1,200p' generate.py
sed : The term 'sed' is not recognized as the name of a cmdlet, function, script file, or operable program. Check the spelling of the name, or if a path
was included, verify that the path is correct and try again.
At line:1 char:1
+ sed -n '1,200p' generate.py
+ ~~~
    + CategoryInfo          : ObjectNotFound: (sed:String) [], CommandNotFoundException
    + FullyQualifiedErrorId : CommandNotFoundException

PS C:\Users\burce> Get-Content .\generate.py -TotalCount 200
Get-Content : Cannot find path 'C:\Users\burce\generate.py' because it does not exist.
At line:1 char:1
+ Get-Content .\generate.py -TotalCount 200
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (C:\Users\burce\generate.py:String) [Get-Content], ItemNotFoundException
    + FullyQualifiedErrorId : PathNotFound,Microsoft.PowerShell.Commands.GetContentCommand

PS C:\Users\burce> Invoke-WebRequest "http://challenge.scy-phy.net:8080/E1/bbc/generate.py" -OutFile generate.py
PS C:\Users\burce> Invoke-WebRequest "http://challenge.scy-phy.net:8080/E1/bbc/intercepted-messages" -OutFile intercepted-messages
PS C:\Users\burce> Get-Content .\generate.py -TotalCount 200
from Crypto.Util.number import *

Ns = [getPrime(1024) * getPrime(1024) for i in range(3)]
e = 3 # Hastad told me this is secure

flag = b"FLAG{REDACTED_REDACTED_}"
flag = b"A" * (126 - len(flag)) + flag

message = bytes_to_long(flag)

for i in range(3):
    print("N"+str(i+1)+" = " + str(Ns[i]))
    print("e"+str(i+1)+" = " + str(e))
    print("encryptedMessage"+str(i+1)+" = " + str(pow(message, e, Ns[i])))
    print()


## Checks

for i in range(3):
    exec("N"+str(i+1)+" = " + str(Ns[i]))
    exec("e"+str(i+1)+" = " + str(e))
    exec("encryptedMessage"+str(i+1)+" = " + str(pow(message, e, Ns[i])))

Ns = [N1, N2, N3]
e = e1
assert e == 3
assert len(Ns) == e

# find the k-th root of n
def iroot(k, n):
    u, s = n, n+1
    while u < s:
        s = u
        t = (k-1) * s + n // pow(s, k-1)
        u = t // k
    return s

from functools import reduce
def chinese_remainder(n, a):
    sum = 0
    prod = reduce(lambda a, b: a*b, n)
    for n_i, a_i in zip(n, a):
        p = prod // n_i
        sum += a_i * mul_inv(p, n_i) * p
    return sum % prod

def mul_inv(a, b):
    b0 = b
    x0, x1 = 0, 1
    if b == 1: return 1
    while a > 1:
        q = a // b
        a, b = b, a%b
        x0, x1 = x1 - q * x0, x0
    if x1 < 0: x1 += b0
    return x1

messageCubed = chinese_remainder(Ns, [encryptedMessage1, encryptedMessage2, encryptedMessage3])

# messageCubed should be a perfect cube
assert iroot(3, messageCubed) ** 3 == messageCubed
assert iroot(3, messageCubed) == message
assert long_to_bytes(iroot(3, messageCubed)) == flag
PS C:\Users\burce> Get-Content .\intercepted-messages -TotalCount 120
N1 = 15726828900699479357664047038162697240495839436622157865060516872184621127288227308048219102869015416984510323063965117265583577029579749620484270674715947701260435792178679039465262290912640748845033866723293295449532258686542565657729741257262251876692928080073218220793684153893430265262421458690141769170995770673156294111922700240814997620673900843465792517230113428546055648168573589235410357732839401214228480965179644065499806080949597274986845329276614565438521830493807639030609819938046244728457539922546767576508932665692826074361397757749527339050557619684336138551151241455036371822432949430311473931979
e1 = 3
encryptedMessage1 = 5975337164278874587592371954084885705712023595422472778955122020885876572145545003496054241457546805624780770959332565906847641555895903519182798368994332832936065980981429060139783481259624894342589451464383120105567888922022649732435799295160859386382881987543782329427182790445740845904298307694674300687863121373226975187383326904796956991070658993137029991273018859626937244958773029110880999084733285753674982573428203126774456025672754732143436364277598054991060019333943038167444908622747489979631645052398924924877601913533094652903098194487341202534253925345167449387675629814971959071469821782409864854680

N2 = 11655869168833193530075690235888684644530357084072175965032204515756548102037386916697680513650345306003917129444381558538082338272649052479010580497237342176075055273074976362307350176774706398579914094873877771604757089082685686993148719175236248729669303346874465712040541166344704638127581107630768164917241121998296398460697001754729826928672731888862121113139890750307942587361531839363319597900913368464802977155545964139561488566956057790898507726960207627195563313088552585722018427306820984559241897644242528070776070726736686095544855609576541783180567444734291931722814285139300025306111419660705008433177
e2 = 3
encryptedMessage2 = 1017230966472412705943420877533017201828108077796925274593015264896431450989455653069146797502229913558062704571805182906560907608046141510328065147098326634951716674222215807109328435692046567261611990675837809604853575162426659237904774988963485580011931949231521556367071215302025985375258929477929930411196327316538703157748607629817742021454154429971410892772907929413283778816905196585936971594558041187302414512343550467958059091047754405300937789078344284315509605525728396063099852079115907733851382122463180851570022140254026113248140976861839284683345397879737466298979363563422591627464161154185079058964

N3 = 22029214391325604626754058881811715175546138369600589704901750544670731298205813066438783568206048638769620314362575963438625086858029667170346298306999260703893873902998791203261484948795904552038934936866924778975386667539245411369598244238197356778958133452764757070018230427493225898759650948040588262232797730523433995645911937365171765903837347616465095867004106669356370137198461803299107780022993778955839938983652803946831615647744647453810211906426275322380123245321334955161369668880494894081146824936425499984303432624490358207968417978029780292953950716971440688260296735186567590901253253480940938094607
e3 = 3
encryptedMessage3 = 15245947744754520157486724130557679793072279852804298961439026172897575494407680299591354306461848296747057963130929120113260250084601547832406418736177631055347456437663996327631815388360787691354760452297830182187483090977425699781687925934879778756540341387288171020124310209772865338914261689979936608555807401425338277575581934979196211903592049790672288902083085586701655809834429631597356685507857658408940837811302168321521628877177621705866766363066411766159496605069105451938456709120823987378472943943833868390474638929688201331180063129484336766255320559454977446618928157596925620331552469885776190205039

PS C:\Users\burce> @'
>> from functools import reduce
>>
>> def mul_inv(a, b):
>>     b0 = b
>>     x0, x1 = 0, 1
>>     if b == 1:
>>         return 1
>>     while a > 1:
>>         q = a // b
>>         a, b = b, a % b
>>         x0, x1 = x1 - q * x0, x0
>>     if x1 < 0:
>>         x1 += b0
>>     return x1
>>
>> def chinese_remainder(mods, rems):
>>     total = 0
>>     prod = reduce(lambda x, y: x * y, mods)
>>     for n_i, a_i in zip(mods, rems):
>>         p = prod // n_i
>>         total += a_i * mul_inv(p, n_i) * p
>>     return total % prod
>>
>> def iroot(k, n):
>>     # integer k-th root via Newton's method, no floats
>>     x = n
>>     while True:
>>         y = ((k - 1) * x + n // (x ** (k - 1))) // k
>>         if y >= x:
>>             return x
>>         x = y
>>
>> def long_to_bytes(n):
>>     length = (n.bit_length() + 7) // 8
>>     return n.to_bytes(length, 'big')
>>
>> # Load all the N1, e1, encryptedMessage1, ... from intercepted-messages
>> ns = {}
>> with open("intercepted-messages", "r") as f:
>>     code = f.read()
>> exec(code, ns)
>>
>> N1, N2, N3 = ns["N1"], ns["N2"], ns["N3"]
>> c1 = ns["encryptedMessage1"]
>> c2 = ns["encryptedMessage2"]
>> c3 = ns["encryptedMessage3"]
>> e1, e2, e3 = ns["e1"], ns["e2"], ns["e3"]
>>
>> assert e1 == e2 == e3
>> e = e1
>>
>> M = chinese_remainder([N1, N2, N3], [c1, c2, c3])  # this is m^e
>> m = iroot(e, M)                                    # cube root
>>
>> pt = long_to_bytes(m)
>> print(pt)
>> print(pt.decode("utf-8", errors="replace"))
>> '@ > solve_bbc.py
PS C:\Users\burce> python3 .\solve_bbc.py
Python bulunamad
PS C:\Users\burce> # See if python or the launcher 'py' exists
PS C:\Users\burce> Get-Command python -ErrorAction SilentlyContinue

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Application     python.exe                                         0.0.0.0    C:\Users\burce\AppData\Local\Microsoft\WindowsApps\python.exe


PS C:\Users\burce> Get-Command py -ErrorAction SilentlyContinue

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Application     py.exe                                             3.13.11... C:\Users\burce\AppData\Local\Programs\Python\Launcher\py.exe


PS C:\Users\burce>
PS C:\Users\burce> # Print versions if found
PS C:\Users\burce> python --version 2>$null; py -3 --version 2>$null
Python 3.13.1
PS C:\Users\burce>
PS C:\Users\burce> # Which file would be run
PS C:\Users\burce> where.exe python 2>$null
C:\Users\burce\AppData\Local\Microsoft\WindowsApps\python.exe
PS C:\Users\burce> where.exe py 2>$null
C:\Users\burce\AppData\Local\Programs\Python\Launcher\py.exe
PS C:\Users\burce> @'
>> from functools import reduce
>>
>> def mul_inv(a, b):
>>     b0 = b
>>     x0, x1 = 0, 1
>>     if b == 1:
>>         return 1
>>     while a > 1:
>>         q = a // b
>>         a, b = b, a % b
>>         x0, x1 = x1 - q * x0, x0
>>     if x1 < 0:
>>         x1 += b0
>>     return x1
>>
>> def chinese_remainder(mods, rems):
>>     total = 0
>>     prod = reduce(lambda x, y: x * y, mods)
>>     for n_i, a_i in zip(mods, rems):
>>         p = prod // n_i
>>         total += a_i * mul_inv(p, n_i) * p
>>     return total % prod
>>
>> def iroot(k, n):
>>     # integer k-th root via Newton's method, returns floor root
>>     x = n
>>     while True:
>>         y = ((k - 1) * x + n // (x ** (k - 1))) // k
>>         if y >= x:
>>             return x
>>         x = y
>>
>> def long_to_bytes(n):
>>     length = (n.bit_length() + 7) // 8
>>     return n.to_bytes(length, 'big')
>>
>> # Read intercepted file and execute assignments to get N1,N2,N3,ciphertexts,e1...
>> ns = {}
>> with open("intercepted-messages", "r") as f:
>>     code = f.read()
>> exec(code, ns)
>>
>> N1, N2, N3 = ns["N1"], ns["N2"], ns["N3"]
>> c1 = ns["encryptedMessage1"]
>> c2 = ns["encryptedMessage2"]
>> c3 = ns["encryptedMessage3"]
>> e1, e2, e3 = ns["e1"], ns["e2"], ns["e3"]
>>
>> assert e1 == e2 == e3
>> e = e1
>>
>> M = chinese_remainder([N1, N2, N3], [c1, c2, c3])  # this is m^e
>> m = iroot(e, M)                                    # exact integer e-th root (floor)
>>
>> pt = long_to_bytes(m)
>> print("Recovered bytes (raw):", pt)
>> print("Recovered plaintext (utf-8):")
>> print(pt.decode("utf-8", errors="replace"))
>> '@ > .\solve_bbc.py
PS C:\Users\burce> python .\solve_bbc.py
Python bulunamad
PS C:\Users\burce> # or
PS C:\Users\burce> py -3 .\solve_bbc.py
SyntaxError: Non-UTF-8 code starting with '\xff' in file C:\Users\burce\solve_bbc.py on line 1, but no encoding declared; see https://peps.python.org/pep-0263/ for details
PS C:\Users\burce> python .\solve_bbc.py
Python bulunamad
PS C:\Users\burce> py -3 .\solve_bbc.py
SyntaxError: Non-UTF-8 code starting with '\xff' in file C:\Users\burce\solve_bbc.py on line 1, but no encoding declared; see https://peps.python.org/pep-0263/ for details
PS C:\Users\burce> ^C
PS C:\Users\burce> py -3 scriptname.py
C:\Users\burce\AppData\Local\Programs\Python\Python313\python.exe: can't open file 'C:\\Users\\burce\\scriptname.py': [Errno 2] No such file or directory
PS C:\Users\burce> Get-Content .\solve_bbc.py | Out-File -Encoding utf8 .\solve_bbc_fixed.py
PS C:\Users\burce> py -3 .\solve_bbc_fixed.py
Recovered bytes (raw): b'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFLAG{l1n34r_tv_1s_d34d!}'
Recovered plaintext (utf-8):
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFLAG{l1n34r_tv_1s_d34d!}
PS C:\Users\burce> Remove-Item .\solve_bbc.py
PS C:\Users\burce> Rename-Item .\solve_bbc_fixed.py solve_bbc.py
PS C:\Users\burce> py -3 solve_bbc.py
Recovered bytes (raw): b'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFLAG{l1n34r_tv_1s_d34d!}'
Recovered plaintext (utf-8):
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFLAG{l1n34r_tv_1s_d34d!}
PS C:\Users\burce>



