package com.mbcTeam.product;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.mbcTeam.user.ReviewVO;

@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductDao dao;

    @Transactional
    @Override
    public void insert(ProductVO vo) {
        dao.insert(vo);
    }
    
    @Override
    public void insertImg(ProductImgVO ivo) {
        dao.insertImg(ivo);
    }
    
    @Override
    public void insertDescImg(ProductDescImgVO divo) {
    	dao.insertDescImg(divo);
    }

    @Override
    public void insertOption(ProductOptionVO option) {
        dao.insertOption(option);
    }

    @Override
    public void update(ProductVO vo) {
        dao.update(vo);
    }

    @Override
    public void delete(ProductVO vo) {
        dao.delete(vo);
    }

    @Override
    public List<ProductVO> select(ProductVO vo) {
        return dao.select(vo);
    }

    @Override
    public ProductVO edit(ProductVO vo) {
        return dao.edit(vo);
    }

    @Override
    public ProductVO detail(int productIdx) {
        return dao.detail(productIdx);
    }

    @Override
    public List<ProductOptionVO> selectOptions(int productIdx) {
        return dao.selectOptions(productIdx);
    }

    @Override
    public List<ReviewVO> selectReviews(int productIdx) {
        return dao.selectReviews(productIdx);
    }

    @Override
    public List<ProductVO> selectAll() {
        return dao.selectAll();
    }

    @Override
    public List<ProductVO> selectByCategory(String category) {
        return dao.selectByCategory(category);
    }
}
