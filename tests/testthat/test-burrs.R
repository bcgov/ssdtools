test_that("dburrs", {
  expect_equal(actuar::dburr(2, shape1 = 1, shape2 = 1, scale = 1), 1/9) 
  expect_equal(dburrIII3(2, lshape1 = log(1), lshape2 = log(1), lscale = log(1)), 1/9) # this seems wrong
  expect_equal(dburrIII3b(2, lshape1 = log(1), lshape2 = log(1), lscale = log(1)), 1/9)  # this seems wrong
  expect_equal(dburrIII3o(2, lshape1 = log(1), lshape2 = log(1), lscale = log(1)), 1/9)  # this seems wrong
  
  expect_equal(actuar::dburr(1, shape1 = 1, shape2 = 1, scale = 1), 1/4) 
  expect_equal(dburrIII3(1, lshape1 = log(1), lshape2 = log(1), lscale = log(1)), 1/4) # this seems wrong
  expect_equal(dburrIII3b(1, lshape1 = log(1), lshape2 = log(1), lscale = log(1)), 1/4) # this seems wrong
  expect_equal(dburrIII3o(1, lshape1 = log(1), lshape2 = log(1), lscale = log(1)), 1/4) # this seems wrong
})

test_that("qburrs", {
  expect_equal(actuar::qburr(3/4, shape1 = 1, shape2 = 1, scale = 1), 3)
  expect_equal(qburrIII3(3/4, lshape1 = log(1), lshape2 = log(1), lscale = log(1)), 3) # this seems wrong
  expect_equal(qburrIII3b(3/4, lshape1 = log(1), lshape2 = log(1), lscale = log(1)), 1/3) 
  expect_equal(qburrIII3o(3/4, lshape1 = log(1), lshape2 = log(1), lscale = log(1)), 3) 
  
  expect_equal(actuar::qburr(1/4, shape1 = 1, shape2 = 1, scale = 1), 1/3)
  expect_equal(qburrIII3(1/4, lshape1 = log(1), lshape2 = log(1), lscale = log(1)), 1/3) # this seems wrong
  expect_equal(qburrIII3b(1/4, lshape1 = log(1), lshape2 = log(1), lscale = log(1)), 3) 
  expect_equal(qburrIII3o(1/4, lshape1 = log(1), lshape2 = log(1), lscale = log(1)), 1/3) # this seems wrong
})

test_that("pburrs", {
  expect_equal(actuar::pburr(3, shape1 = 1, shape2 = 1, scale = 1), 3/4)
  expect_equal(pburrIII3(3, lshape1 = log(1), lshape2 = log(1), lscale = log(1)), 3/4) # this seems wrong
  expect_equal(pburrIII3b(3, lshape1 = log(1), lshape2 = log(1), lscale = log(1)), 1/4) 
  expect_equal(pburrIII3o(3, lshape1 = log(1), lshape2 = log(1), lscale = log(1)), 3/4) 
  
  expect_equal(actuar::pburr(3, shape1 = 1, shape2 = 1, scale = 1), 3/4)
  expect_equal(pburrIII3(3, lshape1 = log(1), lshape2 = log(1), lscale = log(1)), 3/4) # this seems wrong
  expect_equal(pburrIII3b(3, lshape1 = log(1), lshape2 = log(1), lscale = log(1)), 1/4) 
  expect_equal(pburrIII3o(3, lshape1 = log(1), lshape2 = log(1), lscale = log(1)), 3/4) # this seems wrong
})
