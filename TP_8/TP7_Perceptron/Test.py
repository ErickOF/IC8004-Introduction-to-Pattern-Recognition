import numpy as np
import matplotlib.pyplot as plt

height, width = [400, 400]
sigma_x, Ixy, Iyx, sigma_y = [1000, 100, -100, -800]

# Circle values
h = (sigma_x + sigma_y) / 2
k = 0
r = (h**2 + Ixy**2)**0.5

x = np.linespace(0, 1, 1000)
y = (r**2 - (x-h)**2)**0.5

# Line values
x2 = [sigma_y, sigma_x]
y2 = [Iyx, Ixy]

circle1 = plt.Circle((h, k), r, fill=0)
text = plt.text(h, k, 'center', fontsize=12)

fig, ax = plt.subplots()

ax.add_artist(circle1)
ax.set_xlim([-r*1.25, r*1.25])
ax.set_ylim([-r*1.25, r*1.25])

plt.plot([-r*1.25, r*1.25], [0, 0], c='black')
plt.plot([0, 0], [-r*1.25, r*1.25], c='black')
plt.plot(x2, y2)
plt.title('Mohr circle')
plt.show()