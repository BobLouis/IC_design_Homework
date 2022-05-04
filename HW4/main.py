from PIL import Image

img = Image.open("./image.jpg")
(w, h) = img.size
print('w=%d, h=%d', w, h)
img.show()

new_img = img.resize((32, 31))
new_img.show()
new_img.save("image_min.jpg")
imgGray = new_img.convert('L')
imgGray.save('image_gray.jpg')


WIDTH, HEIGHT = imgGray.size
data = list(imgGray.getdata()) # convert image data to a list of integers
# convert that to 2D list (list of lists of integers)
data = [data[offset:offset+WIDTH] for offset in range(0, WIDTH*HEIGHT, WIDTH)]

# At this point the image's pixels are all in memory and can be accessed
# individually using data[row][col].

# For example: //original data
for row in data:
    print(' '.join('{:3}'.format(value) for value in row))

print('\nimg.dat')
#img.dat
img_half = [ [0]*32 for i in range(16)]
for i in range(0,31,2):
    img_half[i>>1] = data[i]

for j in range(len(img_half)): 
        print(' '.join('{:3}'.format(value) for value in img_half[j]))


#cal ans
ans = [[0]*32 for i in range(15)]

for k in range(0,15):
    ans[k][0] =  (data[2*k][0]  + data[2*(k+1)][0])>>1
    ans[k][31] = (data[2*k][31] + data[2*(k+1)][31])>>1
    for i in range(1,31):
        d1 = abs(data[2*k][i-1] - data[2*(k+1)][i+1])
        d2 = abs(data[2*k][i]   - data[2*(k+1)][i])
        d3 = abs(data[2*k][i+1] - data[2*(k+1)][i-1])
        if(d2 <= d1 and d2 <= d3):
            ans[k][i] = (data[2*k][i] +   data[2*(k+1)][i])>>1
        elif (d1 <= d2 and d1 <= d3):
            ans[k][i] = (data[2*k][i-1] + data[2*(k+1)][i+1])>>1
        else:
            ans[k][i] = (data[2*k][i+1] + data[2*(k+1)][i-1])>>1
    
print('\nans')
for j in range(len(ans)): 
        print(' '.join('{:3}'.format(value) for value in ans[j]))

#golden data
print('\ngolden')
for j in range(len(ans)): 
    print(' '.join('{:3}'.format(value) for value in img_half[j]))
    print(' '.join('{:3}'.format(value) for value in ans[j]))
print(' '.join('{:3}'.format(value) for value in img_half[15]))

#write file
img = open("img_zoro.dat", "w")
for i in range(len(img_half)):
    for j in range(len(img_half[0])):
        img.write(str(hex(img_half[i][j]).lstrip("0x")))
        img.write('\n')
img.close()
#golden
gold = open("golden_zoro.dat", "w")
for i in range(len(ans)):
    for j in range(len(img_half[0])):
        gold.write(str(hex(img_half[i][j]).lstrip("0x")))
        gold.write('\n')
    for j in range(len(ans[0])):
        gold.write(str(hex(ans[i][j]).lstrip("0x")))
        gold.write('\n')
for j in range(len(img_half[0])):
        gold.write(str(hex(img_half[15][j]).lstrip("0x")))
        gold.write('\n')
gold.close()

# Here's another more compact representation.
# chars = '@%#*+=-:. '  # Change as desired.
# scale = (len(chars)-1)/255.
# print()
# for row in data:
#     print(' '.join(chars[int(value*scale)] for value in row))