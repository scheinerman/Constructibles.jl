using Constructibles

restart!()

# create a 60° angle from :A
add_point!(CP(CN(1//2), sqrt(CN(3))/2))  # this will be the point :C
ruler(:A, :B)
ruler(:A, :C)

# draw circles around points :B and :C
compass(:C, :A)
compass(:B, :A)

# draw the angle bisector
ruler(:A, :F)
